# -*- indent-tabs-mode: nil -*-

RWiki::Version.regist('map', '2003-03-02')

class MapFormat < RWiki::NaviFormat
  @rhtml = { :view => RWiki::ERbLoader.new('view(pg)', 'map.rhtml')}
  reload_rhtml

  def navi_view(pg, title, referer)
    params = {
      'top' => referer.name,
      'navi' => pg.name,
    }
    %Q[<span class="navi">[<a href="#{ ref_name(pg.name, params) }">#{ h title }</a>]</span>]
  end
end

class RecentFormat < RWiki::NaviFormat
  @rhtml = { :view => RWiki::ERbLoader.new('view(pg)', 'recent.rhtml')}
  reload_rhtml
end

class ListFormat < RWiki::NaviFormat
  @rhtml = { :view => RWiki::ERbLoader.new('view(pg)', 'list.rhtml')}
  reload_rhtml
end

class PageRankFormat < RWiki::NaviFormat
  @rhtml = { :view => RWiki::ERbLoader.new('view(pg)', 'page_rank.rhtml')}
  reload_rhtml
end

RWiki::install_page_module('map', MapFormat, 'Map')

RWiki::install_page_module('recent', RecentFormat, 'Recent')

RWiki::install_page_module('list', ListFormat, 'List')

RWiki::install_page_module('page rank', PageRankFormat, 'Page Rank')
