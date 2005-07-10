require "rwiki/rss/page"

RWiki::Version.regist("rwiki/rss/recent",
                      '$Id: rss.rb 582 2005-05-26 02:14:11Z kou $')

module RWiki
  module RSS
    module Recent

      class Section < RWiki::Section

        def initialize(config, pattern)
          super(config, pattern)
          add_prop_loader(:rss, PropLoader.new)
          add_default_src_proc(method(:default_src))
        end

        path = %w(rss recent default_src.erd)
        ERBLoader.new('default_src(name)', path).load(self)
      end

      class PageFormat < RWiki::PageFormat
        private
        include FormatUtils

        @rhtml = {
          :view => ERBLoader.new('view(pg)', %w(rss recent view.rhtml)),
        }
        reload_rhtml
      end

      
      module_function
      def install
        name = "rss_recent"
        pattern = /\A#{Regexp.escape(name)}\z/
        recent_section = Recent::Section.new(nil, pattern)
        RWiki::Book.section_list.push(recent_section)
        RWiki.install_page_module(name, RWiki::RSS::Recent::PageFormat, 'RSS Recent')
      end
    end
  end
end

RWiki::RSS::Recent.install
