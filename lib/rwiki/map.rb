# -*- indent-tabs-mode: nil -*-

require 'rwiki/rw-lib'
require 'rwiki/gettext'
require 'rwiki/pagemodule'
require 'rwiki/navi'

module RWiki
  
  N_("map")
  N_("recent")
  N_("list")
  N_("page rank")
  
  Version.regist('map', '2003-03-02')
  
  class MapFormat < NaviFormat
    @rhtml = { :view => ERBLoader.new('view(pg)', 'map.rhtml')}
    reload_rhtml
    
    def navi_view(pg, title, referer)
      params = {
        'top' => referer.name,
        'navi' => pg.name,
      }
      %Q[<span class="navi">[<a href="#{ ref_name(pg.name, params) }">#{ h title }</a>]</span>]
    end
  end
  
  class RecentFormat < NaviFormat
    @rhtml = { :view => ERBLoader.new('view(pg)', 'recent.rhtml')}
    reload_rhtml
  end
  
  class ListFormat < NaviFormat
    @rhtml = { :view => ERBLoader.new('view(pg)', 'list.rhtml')}
    reload_rhtml
  end
  
  class PageRankFormat < NaviFormat
    @rhtml = { :view => ERBLoader.new('view(pg)', 'page_rank.rhtml')}
    reload_rhtml
  end
  
  install_page_module('map', MapFormat, _('map'))
  
  install_page_module('recent', RecentFormat, _('recent'))
  
  install_page_module('list', ListFormat, _('list'))
  
  install_page_module('page rank', PageRankFormat, _('page rank'))
end
