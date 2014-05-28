# -*- indent-tabs-mode: nil -*-

require 'rwiki/rw-lib'
require 'rwiki/gettext'
require 'rwiki/pagemodule'

module RWiki
  class RecentFormat < PageFormat
    @rhtml = { :view => ERBLoader.new('view(pg)', 'recent.rhtml')}
    reload_rhtml
  end

  install_page_module('recent', RecentFormat, s_('navi|recent'))
end
