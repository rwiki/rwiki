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

      private
      @rhtml = {
        :rss => ERBLoader.new('rss(pg)', 'recent1.0.rrdf')
      }
      reload_rhtml

      def content_encoded(page)
        diff = page.latest_diff
        if diff and /\A\s*\z/ !~ diff
          page.latest_formatted_diff ||= format_diff(page.name, diff)
          content = page.latest_formatted_diff
          %Q|<content:encoded>#{h content}</content:encoded>|
        else
          ''
        end
      end
      
      def description(page)
        if /\A\s*\z/ !~ page.log.to_s
          %Q|<description>#{h page.log}</description>|
        end
      end

      def dc_date(page)
        if page.modified
          %Q|<dc:date>#{h page.modified.gmtime.iso8601}</dc:date>|
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
