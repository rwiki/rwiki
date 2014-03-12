# -*- indent-tabs-mode: nil -*-

require 'rwiki/rw-lib'
require 'rwiki/gettext'
require 'rwiki/pagemodule'
require 'rwiki/navi'

module RWiki
  class InfoFormat < NaviFormat
  @rhtml = { :view => ERBLoader.new('view(pg)', 'info.rhtml') }
    reload_rhtml
  end

  install_page_module('info', InfoFormat, s_('navi|info'))
end
