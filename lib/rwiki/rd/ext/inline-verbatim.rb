# -*- indent-tabs-mode: nil -*-

require 'rwiki/rd/ext/base'
require 'rwiki/rd/ext/image'

module RD
  module Ext
    class InlineVerbatim < Base
      include Image

      def ext_inline_verb_img(label, content, visitor)
        img(label, content, visitor)
      end
      def self.about_ext_inline_verb_img
        h(%Q!inline image (example: (('img:http://www.ruby-lang.org/image/title.gif')))!)
      end
      
      def ext_inline_verb_quote(label, content, visitor)
        label = label.to_s
        return nil unless /^quote:(.*)$/ =~ label
        CGI.escapeHTML($1)
      end
      def self.about_ext_inline_verb_quote
        h(%Q!for escape other extensions (example: (('quote:quote:hoge')))!)
      end
      
      def ext_inline_verb_del(label, content, visitor)
        label = label.to_s
        return nil unless /^del:(.*)$/ =~ label
        %Q[<del>#{CGI.escapeHTML($1)}</del>]
      end
      def self.about_ext_inline_verb_del
        h(%Q[surround content by <del> (example: (('del:hoge')))])
      end
      
    end # InlineVerbatim
  end # Ext
end # RD
