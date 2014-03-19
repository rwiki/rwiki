# -*- indent-tabs-mode: nil -*-

require 'rwiki/rw-lib'
require 'rwiki/gettext'
require 'rwiki/pagemodule'
require 'rwiki/navi'

module RWiki
  class RecentFormat < NaviFormat
    @rhtml = { :view => ERBLoader.new('view(pg)', 'recent.rhtml')}
    reload_rhtml
  end

  install_page_module('recent', RecentFormat, s_('navi|recent'))
end
