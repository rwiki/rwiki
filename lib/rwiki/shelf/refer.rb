# -*- indent-tabs-mode: nil -*-

require 'rwiki/rd/ext/refer'

module RD
  module Ext
    class Refer
      def ext_refer_shelf(label, content, visitor)
        label = label.to_s
        return nil unless /^amazon:([0-9a-zA-Z]{10})(:title|:image)?$/ =~ label
        asin = $1
        kind = $2
        name = "asin:#{asin}"
        visitor.links.push([name, nil])
        script = %Q!<% shelf = pg.book["#{name}"] %>!
        script << %Q!<a href="<%= ref_url(shelf.amazon_url) %>">!
        if label == content
          if kind == ':image'
            script << %Q!<img src="<%=h shelf.amazon_image_url%>" />!
          else
            script << %Q!<%=h shelf.amazon_title %>!
          end
        else
          script << "#{content}"
        end
        script << "</a>"
        script
      end
      def self.about_ext_refer_shelf
        %Q!example ((<amazon:4756139612>)) or ((<amazon:4756139612:image>))!
      end
    end
  end
end
