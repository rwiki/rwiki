# -*- indent-tabs-mode: nil -*-

require 'rwiki/rw-lib'
require 'rwiki/gettext'
require 'rwiki/pagemodule'
require 'rwiki/navi'

module RWiki

  Version.regist('rwiki/method', '2003-04-29 (Greenery Day)')

  class MethodFormat < NaviFormat
    @rhtml = { :view => ERBLoader.new('view(pg)', 'method.rhtml') }
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
      if /\A[A-Za-z]/ !~ label
        label = 'a' << label
      end
      label.gsub(/([^A-Za-z0-9\-_]+)/n) {
        '.' + $1.unpack('H2' * $1.size).join('.')
      }
    end

  end

  install_page_module('method', MethodFormat, _('method'))

end
