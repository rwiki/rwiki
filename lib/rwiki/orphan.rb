RWiki::Version.regist('rwiki/orphan', '2002-05-09 cloudy')

class OrphanFormat < RWiki::NaviFormat
  @rhtml = { :view => RWiki::ERbLoader.new('view(pg)', 'orphan.rhtml') }
  reload_rhtml
end

RWiki::install_page_module('orphan', OrphanFormat, 'Orphan')
