require 'rwiki/rd/ext/base'

module RD
  module Ext
    class InlineVerbatim
    def ext_inline_asin(label, content, visitor)
      label = label.to_s
      return nil unless /^(asin:[0-9a-zA-Z]{10})(:.+)$/ =~ label
      name = $1
      property = $2

      case property
      when ':image'
        content = %Q[<img src="<%= pg.book['#{name}'].prop(:shelf)[:image_url] rescue ''%>" class="inline" />]
      else
        content = %Q[<%=h pg.book['#{name}'].prop(:shelf)[:title] rescue '#{name}' %>]
      end

      %Q[<a href="<%= pg.book['#{name}'].prop(:shelf)[:url] rescue ''%>" >] +
        content + "</a>"
    end
    def self.about_ext_asin_test
      h(%Q!inline story test (example: (('asin:0123456789:image')))!)
    end
  end
end
end

# RD::RD2RWikiVisitor.install_extension
