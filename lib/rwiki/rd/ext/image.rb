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
        resource = CGI.escapeHTML(uri_str)
        if uri_str == description
          desc = resource
        else
          desc = CGI.escapeHTML(description)
        end
        klass = prop["class"] || "inline"
        %Q[<img src="#{resource}" alt="#{desc}" class="#{klass}" />]
      end
    end
  end
end
