# -*- indent-tabs-mode: nil -*-

require 'rwiki/rw-lib'
require 'rwiki/gettext'
require 'rwiki/pagemodule'
require 'rwiki/navi'

module RWiki

  Version.register('rwiki/{map,recent,list,page rank}', '$Id$')

  class MapFormat < NaviFormat
    @rhtml = { :view => ERBLoader.new('view(pg)', 'map.rhtml')}
    reload_rhtml

    def navi_view(pg, title, referer)
      params = {
        'top' => referer.name,
        'navi' => pg.name,
      }
      %Q|<span class="navi">[<a href="#{ ref_name(pg.name, params) }">#{ h title }</a>]</span>|
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

  install_page_module('map', MapFormat, s_('navi|map'))
  install_page_module('recent', RecentFormat, s_('navi|recent'))
  install_page_module('list', ListFormat, s_('navi|list'))
  install_page_module('page rank', PageRankFormat, s_('navi|page rank'))
end
