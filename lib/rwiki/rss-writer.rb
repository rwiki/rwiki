# -*- indent-tabs-mode: nil -*-

require "time"

RWiki::Request::COMMAND << 'rss'

module RWiki
  Version.regist('rss-writer', '2003-08-14')

  module RSS

    PAGE_NAME = "rss1.0"
    
    class Writer < NaviFormat
      if const_defined?("DESCRIPTION")
        @@description = DESCRIPTION
      else
        @@description = @@title
      end

      def navi_view(pg, title, referer)
        %Q[<span class="navi">[<a href="#{ ref_name(pg.name, {'navi' => pg.name}, 'rss') }">#{ h title }</a>]</span>]
      end

      private
      @rhtml = {
        :rss => ERbLoader.new('rss(pg)', 'recent1.0.rrdf')
      }
      reload_rhtml
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

  install_page_module(RSS::PAGE_NAME, RSS::Writer, 'RSS 1.0')
end
