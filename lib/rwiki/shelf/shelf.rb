# -*- indent-tabs-mode: nil -*-

require 'rwiki/page'
require 'rwiki/section'
require 'rwiki/book'
require 'rwiki/rd/rddoc'
require 'rwiki/shelf/aws'
require 'uri'

raise LoadError unless AmazonCoJp.have_devtag_file?

module RWiki
  module Shelf
    AMAZON = AmazonCoJp.new

    class AsinSection < RWiki::Section
      EXPIRES = 90 * 24 * 60 * 60

      def initialize(config, pattern=/^(isbn|asin):[0-9a-zA-Z]{10}/)
        super(config, pattern)
        add_default_src_proc(method(:default_src))
        add_prop_loader(:shelf, self)
        @page = AsinPage
        @expires = EXPIRES
        @no_tag = false
      end
      attr_accessor :expires, :no_tag

      def create_page(name, book)
        pg = super(name, book)
        pg.src = default_src(name) unless db[name]
        pg
      end
      
      def name_to_asin(name)
        raise 'Invalid ASIN' unless /([0-9a-zA-Z]{10})/ =~ name
        $1
      end

      def default_src(name)
        asin = name_to_asin(name)
        build_asin_page(asin)
      rescue
        "= #{asin}\n #{$!.inspect}"
      end

      def amazon_to_prop(detail)
        prop = {}
        prop[:title] = detail.ProductName
        prop[:asin] = detail.Asin
        prop[:author] = detail.Authors.to_a.join(', ')
        prop[:manufacturer] = detail.Manufacturer
        prop[:release_date] = detail.ReleaseDate
        prop[:image_url] = detail.ImageUrlMedium
        if @no_tag
          prop[:url] = "http://www.amazon.co.jp/exec/obidos/ASIN/#{detail.Asin}"
        else
          prop[:url] = prepare_url_nosim(detail.Url)
        end
        prop
      end

      def prepare_url_nosim(url)
        u = URI.parse(url)
        u.path = u.path + '/ref=nosim'
        u.to_s
      rescue
        "http://www.amazon.co.jp"
      end

      def prop_to_src(prop)
        <<EOS
= asin:#{prop[:asin]}

== #{prop[:title]}

((<(('img:#{prop[:image_url]}'))|URL:#{prop[:url]}>))

== property

* title: #{prop[:title]}
* asin: #{prop[:asin]}
* author: #{prop[:author]}
* manufacturer: #{prop[:manufacturer]}
* release_date: #{prop[:release_date]}
* image_url: #{prop[:image_url]}
* url: #{prop[:url]}

EOS
      end

      def build_asin_page(asin)
        detail = AMAZON.asin_search(asin)
        p detail if $DEBUG
        prop = amazon_to_prop(detail)
        prop_to_src(prop)
      end
      
      def load(content)
        prop = property_section(content.tree, 'property', 2)
        normalize_prop(prop)
      end

      def normalize_prop(prop)
        prop[:title] = prop['title']
        prop[:author] = prop['author']
        prop[:manufacturer] = prop['manufacturer']
        prop[:release_date] = prop['release_date']
        prop[:asin] = normalize_asin(prop['asin'])
        prop[:image_url] = normalize_url(prop['image_url'])
        prop[:url] = normalize_url(prop['url'])
        prop
      end

      def normalize_asin(str)
        return nil unless /^[0-9a-zA-Z]{10}$/ =~ str
        str
      end

      def normalize_url(str)
        url = URI.parse(str)
        url.to_s
      rescue
        'http://www.amazon.co.jp'
      end

      def property_section(tree, title = 'property', level = nil)
        content = search_section(tree, title, level)
        return {} if content.nil?
        ps = RDDoc::PropSection.new
        ps.apply_Section(content)
        ps.prop
      end

      def search_section(tree, title, level = nil)
        sd = RDDoc::SectionDocument.new(tree)
        sd.each_section do |head, content|
          next if level && head.level != level
          return content if sd.as_str(head.title) == title
        end
        nil
      end
    end

    class AsinPage < RWiki::Page
      include ERB::Util

      def renew_if_expired
        return unless @modified
        return unless @modified + @section.expires < Time.now
        set_src(@section.default_src(@name), nil)
      end
      
      def body_erb
        renew_if_expired
        super
      end

      def src
        renew_if_expired
        super
      end

      def prop(key)
        renew_if_expired
        super(key)
      end

      def amazon_url
        shelf = prop(:shelf)
        shelf.fetch(:url, 'http://www.amazon.co.jp')
      end

      def amazon_title
        shelf = prop(:shelf)
        shelf.fetch(:title, 'NotFound')
      end

      def amazon_image_url
        shelf = prop(:shelf)
        shelf.fetch(:image_url, 'http://www.amazon.co.jp')
      end
    end

    class WorkPlaceSection < RWiki::Section
      def initialize(config, pattern=/^asin\-search:/)
        super(config, pattern)
        @page = WorkPlacePage
      end
    end

    class WorkPlacePage < RWiki::Page
      def query_blended(query)
        query_str = query.join(' ')
        result = "\n== #{query_str}\n\n"
        AMAZON.blended_search(query_str).each do |product_line|
          result << "\n=== #{product_line.Mode}\n"
          product_line.ProductInfo.Details.each do |detail|
            asin = detail.Asin
            title = detail.ProductName
            result << "* ((<asin:#{asin}>)) - #{title}\n"
          end
        end
        result
      rescue
        result << "failed\n"
        result
      end

      def prepare_src(v)
        query = []
        new_src = ""
        v.each_line do |line|
          if /^Q:\s*(\S.*?)\s*$/i =~ line
            query << $1
            new_src << "Q: \n"
          else
            new_src << line
          end
        end
        if query.empty?
          v
        else
          new_src + query_blended(query)
        end
      end

      def set_src(v, rev, &block)
        v = prepare_src(v)
        super(v, rev, &block)
      end
    end

    def install(no_tag = false)
      asin_section = AsinSection.new(nil)
      asin_section.no_tag = no_tag
      RWiki::Book.section_list.push(asin_section)
      RWiki::Book.section_list.push(WorkPlaceSection.new(nil))
    end
    module_function :install
  end
end

# RWiki::Shelf.install
#  or
# RWiki::Shelf.install(true)

