# -*- indent-tabs-mode: nil -*-

require 'rwiki/rw-lib'
require 'rwiki/gettext'
require 'rwiki/pagemodule'
require 'rwiki/navi'

module RWiki
  class LocaleSelectFormat < NaviFormat
    @rhtml = {:locale_select => ERBLoader.new('locale_select(pg, title, referer, cmd="view")', 'locale_select.rhtml')}
    reload_rhtml

    def navi_view(pg, title, referer)
      locale_select(pg, title, referer, get_var("cmd", "view"))
    end

    def always_header?
      true
    end
  end

  install_page_module('locale', LocaleSelectFormat, s_("button|change"))
end
