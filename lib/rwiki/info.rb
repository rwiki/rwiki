
RWiki::Version.regist('rwiki/info', '2003-08-02 cloudy')

class InfoFormat < RWiki::NaviFormat
  @rhtml = { :view => RWiki::ERbLoader.new('view(pg)', 'info.rhtml') }
  reload_rhtml
end

RWiki::install_page_module('info', InfoFormat, _('info'))
