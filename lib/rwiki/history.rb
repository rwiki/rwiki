# -*- indent-tabs-mode: nil -*-

require "time"
require 'rwiki/rw-lib'
require 'rwiki/gettext'
require 'rwiki/pagemodule'
require 'rwiki/navi'
require 'rwiki/diff-utils'

module RWiki

  Version.regist('rwiki/history', '$Id$')

  class HistoryFormat < NaviFormat
    include DiffLink

    @rhtml = { :view => ERBLoader.new('view(pg)', 'history.rhtml')}
    reload_rhtml
  end

  class DiffFormat < NaviFormat
    include DiffLink
    include DiffFormatter

    @rhtml = { :view => ERBLoader.new('view(pg)', 'diff.rhtml')}
    reload_rhtml

    def diff(pg, log1, log2)
      result = nil
      if log1 and log2
        result = pg.book[target(TOP_NAME)].diff(log1.revision, log2.revision)
        result = nil if /\A\s*\z/ =~ result
      end
      result
    end

    private
    def get_revesion_and_log(logs, request_rev)
      rev = request_rev
      log = logs[rev]
      rev = logs.index(log) if rev < 0
      [rev, log]
    end
  end

  install_page_module('history', HistoryFormat, s_("navi|history"))
  install_page_module('diff', DiffFormat, s_("navi|diff"))
end
