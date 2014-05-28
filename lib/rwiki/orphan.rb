# -*- indent-tabs-mode: nil -*-

require 'rwiki/rw-lib'
require 'rwiki/gettext'
require 'rwiki/pagemodule'

module RWiki
  class OrphanFormat < PageFormat
    @rhtml = { :view => ERBLoader.new('view(pg)', 'orphan.rhtml') }
    reload_rhtml
  end

  install_page_module('orphan', OrphanFormat, s_("navi|orphan"))
end
