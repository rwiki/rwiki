# -*- indent-tabs-mode: nil -*-

require "rwiki/gettext"
require "rwiki/navi"
require 'rwiki/pagemodule'

module RWiki

  Version.regist('rwiki/search', '$Id$')

  class SearchFormat < NaviFormat
    @rhtml = { :view => ERBLoader.new('view(pg)', 'search.rhtml')}
    reload_rhtml

    def navi_view(pg, title, referer)
      <<-HTML
<form action="#{ form_action() }" method="get" class="search">
<div class="search">
#{form_hidden('search')}
<input name="navi" type="hidden" value="#{ h(pg.name) }" />
<input name="key" type="text" value="#{ h(var('key')) }" size="10" #{tabindex} accesskey="K" />
<input name="submit" type="submit" value="#{ h title }" #{tabindex} accesskey="G" />
</div>
</form>
      HTML
    end
  end

  install_page_module("search", SearchFormat, s_("navi|search"))
end
