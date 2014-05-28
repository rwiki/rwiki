# -*- indent-tabs-mode: nil -*-

require "rwiki/gettext"
require 'rwiki/pagemodule'

module RWiki
  class SrcFormat < PageFormat
    def navi_view(pg, title, referer)
      %Q|<span class="navi">[<a href="#{ ref_name(referer.name, {'navi' => pg.name}, 'src') }">#{ h title }</a>]</span>|
    end
  end

  install_page_module("src", SrcFormat, s_("navi|src"))
end
