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
    MAX_PAGES = 100

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
        time = changes.empty? ? Time.at(0) : changes.first[1]
        full_rss_url = full_ref_name(::RWiki::RSS::PAGE_NAME, {}, "rss")
        key = [full_rss_url, changes.size]
        cache_with(key, time) do
          processor = Proc.new do |page, modified, log_thunk, diff_thunk, rev|
            params = {}
            params["rev"] = rev if rev
            uri = full_ref_name(page.name, params)
            log = log_thunk ? log_thunk.call : nil
            diff = diff_thunk ? diff_thunk.call : nil
            [page, modified, log, diff, uri]
          end
          _rss(pg, changes.collect(&processor))
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

            changes.each do |page, modified, log, diff, uri|
              item = maker.items.new_item
              item.title = page.title
              item.link = uri
              item.description = log
              item.dc_date = modified
              item.content_encoded = diff
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
        pages = pg.book.recent_changes[range]
        rec_chan = []
        limit = pages.last.modified || Time.at(0)
        pages.each_with_index do |page, i|
          logs = page.logs
          if logs.empty?
            next unless page.modified.kind_of?(Time)
            rec_chan << [page, page.modified, nil, nil, nil]
          else
            rec_chan.concat(collect_changes_from_logs(page, logs, limit))
          end
        end
        rec_chan.sort_by{|_, m, _, _| m}.reverse[range][0...MAX_PAGES]
      end

      def collect_changes_from_logs(page, logs, limit)
        changes = []
        logs.each_with_index do |log, i|
          next unless log.date.kind_of?(Time)
          break if limit > log.date
          _log = log
          commit_log = Proc.new{string_value(_log.commit_log)}
          diff = Proc.new do
            prev_log = logs[i + 1]
            prev_rev = nil
            prev_rev = prev_log.revision if prev_log
            d = page.diff(prev_rev, _log.revision)
            string_value(d) {|v| format_diff(page.name, v)}
          end
          revision = i.zero? ? nil : log.revision
          changes << [page, log.date, commit_log, diff, revision]
        end
        changes
      end

      def string_value(value)
        if value and /\A\s*\z/ !~ value
          if block_given?
            yield value
          else
            value
          end
        else
          nil
        end
      end

      def content_encoded(value)
        string_value(value) do |v|
          %Q|<content:encoded>#{h v}</content:encoded>|
        end
      end

      def description(value)
        string_value(value) do |v|
          %Q|<description>#{h v}</description>|
        end
      end

      def dc_date(date)
        if date
          %Q|<dc:date>#{h date.gmtime.iso8601}</dc:date>|
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
        dc_date(latest_modified_time(page))
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
      body = Response::Body.new(content, "application/xml")
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
