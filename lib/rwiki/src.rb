# -*- indent-tabs-mode: nil -*-

require "rwiki/gettext"
require "rwiki/navi"
require 'rwiki/pagemodule'

module RWiki

  Version.regist('rwiki/src', '2004-11-23')

  class SrcFormat < NaviFormat
    def navi_view(pg, title, referer)
      %Q|<span class="navi">[<a href="#{ ref_name(referer.name, {'navi' => pg.name}, 'src') }">#{ h title }</a>]</span>|
    end

    def revision_info(rev)
      if rev.nil?
        ""
      else
        "(#{h rev})"
      end
    end

    
  end

  install_page_module("src", SrcFormat, s_("navi|src"))

end
