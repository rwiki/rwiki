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
        url = $1
        scheme =
                begin
                  URI.parse(url).scheme
                rescue
                  return nil
                end
        unless ALLOWED_IMG_URL_SCHEME.include?(scheme.to_s.downcase)
          return nil
        end
        resource = CGI.escapeHTML(url)
        content = CGI.escapeHTML(content)
        if label == content
          %Q[<img src="#{resource}" alt="#{url}" class="inline" />]
        else
          %Q[<img src="#{resource}" alt="#{content}" class="inline" />]
        end
      end
    end
  end
end
