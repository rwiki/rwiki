# -*- indent-tabs-mode: nil -*-

require "rwiki/navi"
require "rwiki/gettext"
require 'rwiki/pagemodule'

module RWiki

  Version.regist('rwiki/edit', '2004-11-23')

  class EditFormat < NaviFormat
    def navi_view(pg, title, referer)
      %Q|<span class="navi">[<a href="#{ ref_name(referer.name, {'navi' => pg.name}, 'edit') }">#{ h title }</a>]</span>|
    end
  end

  install_page_module("edit", EditFormat, s_("navi|edit"))

end
