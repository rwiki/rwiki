# -*- indent-tabs-mode: nil -*-

require "time"
require 'rwiki/rw-lib'
require 'rwiki/page'
require 'rwiki/front'
require 'rwiki/gettext'
require 'rwiki/pagemodule'
require 'rwiki/navi'
require 'rwiki/hooks'
require 'rwiki/diff-utils'

module RWiki

  Version.regist('rss/writer', '$Id$')

  module RSS

    PAGE_NAME = "rss1.0"

    class Writer < NaviFormat
      include DiffFormatter

      @@mutex = Mutex.new
      
      def self.clear_cache(time)
        @@mutex.synchronize do
          @@cache = {:time => time}
        end
      end

      clear_cache(Time.at(0))
      
      if const_defined?("DESCRIPTION")
        @@description = DESCRIPTION
      else
        @@description = @@title
      end

      def navi_view(pg, title, referer)
        %Q|<span class="navi">[<a href="#{ ref_name(pg.name, {'navi' => pg.name}, 'rss') }">#{ h title }</a>]</span>|
      end

      @rhtml = {
        :xsl =>  ERBLoader.new('xsl(pg)', ['rss', 'rss1.0.rxsl'])
      }

      def rss(pg)
        changes = recent_changes(pg)
        time = changes.empty? ? Time.at(0) : changes.first.modified
        full_rss_url = full_ref_name(::RWiki::RSS::PAGE_NAME, {}, "rss")
        key = [full_rss_url, changes.size]
        cache_with(key, time) do
          _rss(pg, changes)
        end
      end
      
      begin
        require "rss/maker"

        def self.using_rss_maker?
          true
        end
        
        def _rss(pg, changes)
          full_rss_url = full_ref_name(::RWiki::RSS::PAGE_NAME, {}, "rss")
          full_xsl_url = full_ref_name(::RWiki::RSS::PAGE_NAME, {}, "xsl")
          full_top_url = full_ref_name(::RWiki::TOP_NAME)

          rss = ::RSS::Maker.make("1.0") do |maker|
            maker.encoding = @@charset

            xss = maker.xml_stylesheets.new_xml_stylesheet
            xss.href = full_xsl_url
            xss.type = "text/xsl"
            
            maker.channel.about = full_rss_url
            maker.channel.title = @@title
            maker.channel.link = full_top_url
            maker.channel.description = @@description
            maker.channel.dc_language = @@lang
            maker.channel.dc_date = latest_modified_time(pg)
            maker.channel.dc_publisher = @@address if @@address
            maker.channel.dc_creator = @@mailto if @@mailto
            
            if image
              maker.image.title = @@title
              maker.image.url = image
            end

            if maker.channel.respond_to?(:image_favicon)
              if favicon and favicon_size
                maker.channel.image_favicon.about = favicon
                maker.channel.image_favicon.image_size = favicon_size
              end
            end
            
            changes.each do |page|
              item = maker.items.new_item
              item.title = page.title
              item.link = full_ref_name(page.name)
              item.description = description_value(page)
              item.dc_date = page.modified
              item.content_encoded = content_encoded_value(page)
            end

            maker.textinput.title = @@title
            maker.textinput.description = "Search #{@@description}"
            maker.textinput.name = "key"
            maker.textinput.link = full_ref_name("search")
          end

          rss.to_s
        end
      rescue LoadError
        def self.using_rss_maker?
          false
        end
        
        @rhtml[:rss] = ERBLoader.new('_rss(pg, changes)', ['rss', 'recent1.0.rrdf'])
      end
      reload_rhtml
      
      private
      def recent_changes(pg)
        key = "pages"
        default = 30
        num, range, have_more = limit_number(key, default, pg.book.size)
        rec_chan = pg.book.recent_changes[range]
        rec_chan.reject!{|page| not page.modified.kind_of?(Time)}
        rec_chan
      end
      
      def content_encoded(page)
        value = content_encoded_value(page)
        if value
          %Q|<content:encoded>#{h value}</content:encoded>|
        end
      end

      def content_encoded_value(page)
        diff = page.latest_diff
        if diff and /\A\s*\z/ !~ diff
          page.latest_formatted_diff{format_diff(page.name, diff)}
        else
          nil
        end
      end
      
      def description(page)
        value = description_value(page)
        if value
          %Q|<description>#{h value}</description>|
        end
      end

      def description_value(page)
        if /\A\s*\z/ !~ page.log.to_s
          page.log
        else
          nil
        end
      end
      
      def dc_date(page)
        value = dc_date_value(page)
        if value
          %Q|<dc:date>#{h value}</dc:date>|
        end
      end

      def dc_date_value(page)
        if page.modified
          page.modified.gmtime.iso8601
        else
          nil
        end
      end

      def latest_modified_time(page)
        changes = page.book.recent_changes
        if changes.empty?
          nil
        else
          changes.first.modified
        end
      end

      def dc_date_latest_modified_time(page)
        time = latest_modified_time(page)
        if time
          %Q|<dc:date>#{h time.gmtime.iso8601}</dc:date>|
        end
      end

      def cache_with(key, time)
        self.class.clear_cache(time) if @@cache[:time] < time
        if @@cache.has_key?(key)
          @@cache[key]
        else
          @@cache[key] = yield
        end
      end
    end

  end

  class Page
    def rss(env={}, &block)
      @format.new(env, &block).rss(self)
    end
    def xsl(env={}, &block)
      @format.new(env, &block).xsl(self)
    end
  end

  class Front
    def rss_view(env={}, &block)
      @book[RSS::PAGE_NAME].rss(env, &block)
    end
    def xsl_view(env={}, &block)
      @book[RSS::PAGE_NAME].xsl(env, &block)
    end

    def do_get_rss(req, env={}, &block)
      make_xml_response(rss_view(env, &block))
    end
    def do_get_xsl(req, env={}, &block)
      make_xml_response(xsl_view(env, &block))
    end

    def make_xml_response(content)
      header = Response::Header.new
      body = Response::Body.new(content)
      body.type = "application/xml"
      Response.new(header, body)
    end
  end

  Request::COMMAND.concat(%w(rss xsl))
  
  install_page_module(RSS::PAGE_NAME, RSS::Writer, s_('navi|RSS 1.0'))

  rss_auto_discovery_hook = Hooks::Hook.new
  def rss_auto_discovery_hook.to_html(pg, format)
    url = format.full_ref_name(RSS::PAGE_NAME, {}, 'rss')
    %Q!<link rel="alternate" type="application/rss+xml" ! +
      %Q!title="RSS" href="#{url}" />!
  end
  Hooks.install_header_hook(rss_auto_discovery_hook)
end
