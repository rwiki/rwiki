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

  Request::COMMAND << 'rss'

  Version.regist('rss/writer', '$Id$')

  module RSS

    PAGE_NAME = "rss1.0"

    class Writer < NaviFormat
      include DiffFormatter
      
      if const_defined?("DESCRIPTION")
        @@description = DESCRIPTION
      else
        @@description = @@title
      end

      def navi_view(pg, title, referer)
        %Q|<span class="navi">[<a href="#{ ref_name(pg.name, {'navi' => pg.name}, 'rss') }">#{ h title }</a>]</span>|
      end

      begin
        require "rss/maker"
        
        def rss(pg)
          rec_chan = recent_changes(pg)
          full_rss_url = full_ref_name(::RWiki::RSS::PAGE_NAME, {}, "rss")
          full_top_url = full_ref_name(::RWiki::TOP_NAME)

          rss = ::RSS::Maker.make("1.0") do |maker|
            maker.encoding = @@charset
            
            maker.channel.about = full_rss_url
            maker.channel.title = @@title
            maker.channel.link = full_top_url
            maker.channel.description = @@description
            maker.channel.dc_language = @@lang
            maker.channel.dc_date = pg.book[::RWiki::TOP_NAME].modified
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
            
            rec_chan.each do |page|
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
        @rhtml = {
          :rss => ERBLoader.new('rss(pg)', ['rss', 'recent1.0.rrdf'])
        }
        reload_rhtml
      end

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
          page.latest_formatted_diff ||= format_diff(page.name, diff)
          page.latest_formatted_diff
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
    end

  end

  class Page
    def rss(env = {}, &block)
      @format.new(env, &block).rss(self)
    end
  end

  class Front
    def rss_view(env = {}, &block)
      @book[RSS::PAGE_NAME].rss(env, &block)
    end
  end

  install_page_module(RSS::PAGE_NAME, RSS::Writer, s_('navi|RSS 1.0'))

  rss_auto_discovery_hook = Hooks::Hook.new
  def rss_auto_discovery_hook.to_html(pg, format)
    url = format.full_ref_name(RSS::PAGE_NAME, {}, 'rss')
    %Q!<link rel="alternate" type="application/rss+xml" ! +
      %Q!title="RSS" href="#{url}" />!
  end
  Hooks.install_header_hook(rss_auto_discovery_hook)
end
