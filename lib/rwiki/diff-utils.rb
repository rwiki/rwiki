require "rwiki/content"

module RWiki
  module DiffLink
    def history_link(targ)
      title = _("history")
      %Q!<a href="#{history_href(targ)}">#{h(title)}</a>!
    end

    def history_href(targ)
      ref_name('history', {"target" => targ,})
    end

    def diff_link(targ, r1, r2)
      if r1 >= 0 and r2 > 0
        %Q|[<a href="#{diff_href(targ, r1, r2)}">#{r1}&lt;=&gt;#{r2}</a>]|
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
        'target' => target(referer.name),
        'navi' => pg.name,
      }
      %Q|<span class="navi">[<a href="#{ref_name(pg.name, params)}">#{ h title }</a>]</span>|
    end
  end

  module DiffFormatter
    include ERB::Util

    def format_diff(name, diff)
      indent = '  '
      content = "#{indent}# enscript diffu\n"
      content << diff.collect{|line| "#{indent}#{line}"}.join('')
      content = RWiki::Content.new(name, content)
      result = content.body_erb.result(binding)
      if /\A<pre class="enscript">/ =~ result
        result
      else
        %Q|<pre class="diff">#{add_diff_span(diff)}</pre>|
      end
    end

    def add_diff_span(diff)
      diff.gsub(/^([+-])?.*$/) do
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
end
