# -*- indent-tabs-mode: nil -*-

require 'uri'
require 'cgi'

module RD
  module Ext
    module Image
      ALLOWED_IMG_URL_SCHEME = ['http', 'https']
      def img(label, content, visitor)
        label = label.to_s
        return nil unless /^img:\s*(.+)$/ =~ label
        uri = $1
        if label == content
          desc = uri
        else
          desc = content
        end
        make_image(visitor, uri, desc)
      end

      def make_image(visitor, uri_str, description, prop={})
        uri = nil
        begin
          uri = URI.parse(uri_str)
        rescue URI::Error
          return nil
        end
        unless ALLOWED_IMG_URL_SCHEME.include?(uri.scheme.to_s.downcase)
          return nil
        end
        klass = prop["class"] || "inline"
        title = prop['title']
        title = title ? CGI.unescapeHTML(title) : description
        attrs = {
          'src' => uri_str,
          'alt' => description,
          'title' => title,
          'class' => klass,
        }
        %Q|<img #{to_attr(attrs)} />|
      end
    end
  end
end
