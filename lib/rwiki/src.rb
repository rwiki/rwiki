# -*- indent-tabs-mode: nil -*-

require "rwiki/gettext"
require "rwiki/navi"
require 'rwiki/pagemodule'

module RWiki

  N_('src')
  
  class SrcFormat < NaviFormat
    def navi_view(pg, title, referer)
      %Q[<span class="navi">[<a href="#{ ref_name(referer.name, {'navi' => pg.name}, 'src') }">#{ h title }</a>]</span>]
    end
  end

  install_page_module("src", SrcFormat, _("src"))
  
end