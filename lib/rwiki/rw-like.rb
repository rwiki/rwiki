# -*- indent-tabs-mode: nil -*-

RWiki::Version.regist('rw-like', '2003-02-09')

class LikeFormat < RWiki::NaviFormat
  @rhtml = { :view => RWiki::ERbLoader.new('view(pg)', 'like.rhtml')}
  reload_rhtml

  def navi_view(pg, title, referer)
    params = {
      'key' => referer.name,
      'navi' => pg.name,
    }
    %Q[<span class="navi">[<a href="#{ ref_name(pg.name, params) }">#{ h title }</a>]</span>]
  end
end

RWiki::install_page_module('like', LikeFormat, 'Like')
