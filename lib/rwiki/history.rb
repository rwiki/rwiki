# -*- indent-tabs-mode: nil -*-

require "time"
require 'rwiki/rw-lib'
require 'rwiki/gettext'
require 'rwiki/pagemodule'
require 'rwiki/navi'

module RWiki
  
  Version.regist('rwiki/history', '2004-03-14')

  module DiffLink
    def diff_link(targ, r1, r2)
      if r1 >= 0 and r2 > 0
        %Q{[<a href="#{diff_href(targ, r1, r2)}">#{r1}&lt;=&gt;#{r2}</a>]}
      end
    end

    def diff_href(targ, r1, r2)
      ref_name("diff", {"target" => targ, "rev1" => r1, "rev2" => r2,})
    end
    
    def target(default=TOP_NAME)
      get_var("target", default)
    end

    def rev1
      get_var("rev1", rev2 - 1).to_i
    end
  
    def rev2
      get_var("rev2", "-1").to_i
    end

    def navi_view(pg, title, referer)
      params = {
        'target' => target(nil) || referer.name,
        'navi' => pg.name,
      }
      %Q[<span class="navi">[<a href="#{ref_name(pg.name, params)}">#{ h title }</a>]</span>]
    end
  end

  class HistoryFormat < NaviFormat
    include DiffLink
    
    @rhtml = { :view => ERBLoader.new('view(pg)', 'history.rhtml')}
    reload_rhtml
  end

  class DiffFormat < NaviFormat
    include DiffLink

    @rhtml = { :view => ERBLoader.new('view(pg)', 'diff.rhtml')}
    reload_rhtml

    def diff(pg, log1, log2)
      result = nil
      if log1 and log2
        result = pg.book[target].diff(log1.revision, log2.revision)
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
    
    def add_diff_span(str)
      str.gsub(/^([+-])?.*$/) do
        case $1
        when "+"
          make_diff_span("added", $MATCH)
        when "-"
          make_diff_span("deleted", $MATCH)
        else
          h($MATCH)
        end
      end
    end
    
    def make_diff_span(type, content)
      %Q[<span class="diff-#{type}">#{h(content)}</span>]
    end
    
  end

  install_page_module('history', HistoryFormat, _("history"))
  install_page_module('diff', DiffFormat, _("diff"))
end
