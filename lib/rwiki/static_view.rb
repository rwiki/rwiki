require "rwiki/format"
require "rwiki/front"
require "rwiki/page"
require "rwiki/rd/rd2rwiki-lib"

module RWiki
  class Front
    def static_view(name, env = {}, &block)
      @book[name].static_view(env, &block)
    end
  end

  class Page
    def static_view_html(env = {}, &block)
      @format.new(env, &block).static_view(self)
    end
  end

  class PageFormat
    @rhtml[:static_view] = ERBLoader.new('static_view(pg)', 'static_view.rhtml')
    @rhtml[:static_view].reload(self)
  end
end

module RD
  class RD2RWikiVisitorStaticSupport < RD2RWikiVisitor
    def default_ext_refer(label, content)
      ref = rwiki_refer(label)
      mod = rwiki_mod(label.wikiname)
      cls = rwiki_mod_class(label.wikiname)
      %Q[<% if env('static_view') %>] <<
        %Q[<a href="#{ref}">#{content}</a>] <<
        %Q[<% else %>] <<
        %Q[<a href="#{ref}" title="#{mod}" class="#{cls}">#{content}</a>] <<
        %Q[<% end %>]
    end
  end # RD2RWikiVisitorStaticSupport
end # RD
$Visitor_Class = RD::RD2RWikiVisitorStaticSupport
