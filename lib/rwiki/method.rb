# -*- indent-tabs-mode: nil -*-

require 'rwiki/encode'
require 'rwiki/gettext'
require 'rwiki/pagemodule'
require 'rwiki/rw-lib'

module RWiki
  class MethodFormat < PageFormat
    @rhtml = { :view => ERBLoader.new('view(pg)', 'method.rhtml') }
    @rhtml[:static_view] = ERBLoader.new('static_view(pg)', 'method_static_view.rhtml')
    reload_rhtml

    def all_method(book)
      book.each do |pg|
        pg.method_list.each do |method|
          yield(pg.name, method)
        end
      end
    end

    def method_index(book)
      dic = {}
      all_method(book) do |pg, m|
        dic[m[3]] = [] unless dic[m[3]]
        dic[m[3]].push [pg, m]
      end
      dic
    end

    def label2anchor(label)
      ::RWiki::Encode.label2anchor(label)
    end

  end

  install_page_module('method', MethodFormat, s_("navi|method"))

end
