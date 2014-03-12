# -*- indent-tabs-mode: nil -*-

require "shellwords"

require "rwiki/gettext"
require "rwiki/navi"
require 'rwiki/pagemodule'

module RWiki
  class SearchFormat < NaviFormat
    @rhtml = { :view => ERBLoader.new('view(pg)', 'search.rhtml')}
    reload_rhtml

    def navi_view(pg, title, referer)
      <<-HTML
<form action="#{ form_action() }" method="get" class="search">
<div class="search">
#{form_hidden('search')}
<input name="navi" type="hidden" value="#{ h(pg.name) }" />
<input name="key" type="text" value="#{ h(get_var('key')) }" size="10" #{tabindex} accesskey="K" />
<input name="submit" type="submit" value="#{ h title }" #{tabindex} accesskey="G" />
</div>
</form>
      HTML
    end

    private
    def search_pages_by_and(book, keywords)
      keyword_res = keywords.collect{|keyword| /#{Regexp.escape(keyword)}/i}
      book.search_body(keyword_res)
    end

    def search_pages_from_title(book, keyword)
      if book.include_name?(keyword)
        [book[keyword]]
      else
        book.search_title(/^#{Regexp.escape(keyword)}/i)
      end
    end

    def search_pages_from_title_by_or(book, keywords)
      name = keywords.find{|key| book.include_name?(key)}
      if name
        [book[name]]
      else
        book.search_title(/^(#{make_or_regexp_str(keywords)})/i)
      end
    end

    def em_link(page, keywords)
      params = keywords.collect{|key| ['em', key]}
      link_and_modified(page, params)
    end

    def make_or_regexp_str(keywords)
      keywords.collect do |keyword|
        Regexp.escape(keyword)
      end.join("|")
    end
  end

  install_page_module("search", SearchFormat, s_("navi|search"))
end
