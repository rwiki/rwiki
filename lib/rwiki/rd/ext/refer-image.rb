# -*- indent-tabs-mode: nil -*-

require 'rwiki/rd/ext/refer'
require 'rwiki/rd/ext/image'

module RD
  module Ext
    class Refer
      include Image

      # For backward compatibility.
      def ext_refer_img(label, content, visitor)
        img(label, content, visitor)
      end
      def self.about_ext_refer_img
        h(_("for backward compatibility (example: ((<img:http://www.ruby-lang.org/image/title.gif>)))"))
      end

    end
  end
end
