# -*- indent-tabs-mode: nil -*-

require 'rwiki/rw-lib'
require 'rwiki/gettext'
require 'rwiki/pagemodule'
require 'rwiki/navi'

module RWiki
  
  N_("concat")

  Version.regist('rwiki/concat', '2002-05-09 cloudy')

  class ConcatFormat < NaviFormat

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

    @rhtml = { :view => ERBLoader.new('view(pg)', 'concat.rhtml')}
    reload_rhtml
  end

  install_page_module('concat', ConcatFormat, _('concat'))

end

