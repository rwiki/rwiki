# -*- indent-tabs-mode: nil -*-

require 'rwiki/rw-lib'
require 'rwiki/gettext'
require 'rwiki/pagemodule'
require 'rwiki/navi'

module RWiki
  Version.regist('rwiki/info', '2003-08-02 cloudy')

  class InfoFormat < NaviFormat
  @rhtml = { :view => ERBLoader.new('view(pg)', 'info.rhtml') }
    reload_rhtml
  end

  install_page_module('info', InfoFormat, _('info'))
end
