# -*- indent-tabs-mode: nil -*-

require "rwiki/gettext"
require "rwiki/navi"
require 'rwiki/pagemodule'

module RWiki

  N_('search')

  class SearchFormat < NaviFormat
    @rhtml = { :view => ERBLoader.new('view(pg)', 'search.rhtml')}
    reload_rhtml

    def navi_view(pg, title, referer)
      %Q|<form action="#{ form_action() }" method="get" class="search">\n<div class="search">\n| <<
        %Q|#{form_hidden('search')}\n| <<
        %Q|<input name="navi" type="hidden" value="#{ h(pg.name) }" size="10" #{tabindex} accesskey="K" />\n| <<
        %Q|<input name="key" type="text" value="#{ h(var('key')) }" size="10" #{tabindex} accesskey="K" />\n| <<
        %Q|<input name="submit" type="submit" value="#{ h title }" #{tabindex} accesskey="G" />\n| <<
        %Q|</div>\n</form>\n|
    end
  end
  
  install_page_module("search", SearchFormat, _("search"))
end
