# -*- indent-tabs-mode: nil -*-

RWiki::Version.regist('rw-concat', '2002-05-09 cloudy')

class ConcatFormat < RWiki::NaviFormat

  LABEL_PREFIX = "concat_"

  def navi_view(pg, title, referer)
    params = {
      'top' => referer.name,
      'navi' => pg.name,
    }
    %Q[<span class="navi">[<a href="#{ref_name(pg.name, params)}">#{ h title }</a>]</span>]
  end

  private
  def make_id(name)
    h(u("#{LABEL_PREFIX}#{name}")).gsub(/%/, ".")
  end

  @rhtml = { :view => RWiki::ERbLoader.new('view(pg)', 'concat.rhtml')}
  reload_rhtml
end

RWiki::install_page_module('concat', ConcatFormat, 'Concat')

