# -*- indent-tabs-mode: nil -*-

N_("like")

RWiki::Version.regist('rwiki/like', '2003-02-09')

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

RWiki::install_page_module('like', LikeFormat, _('like'))
