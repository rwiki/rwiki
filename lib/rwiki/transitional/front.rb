# -*- indent-tabs-mode: nil -*-

require "erb"
require "iconv"
require "rwiki/encode"
require "rwiki/front"
require "rwiki/transitional/format"

module RWiki
  module Transitional
    class Front < ::RWiki::Front
      include ERB::Util

      def initialize(book, new_enc, old_enc)
        @book = book
        @new_enc = new_enc
        @old_enc = old_enc
      end

      private

      def convert(name)
        Iconv.conv(@new_enc, @old_enc, name)
      end

      def do_get_view(req, env={}, &block)
        pagename = req.name
        page = @book[pagename]
        if page.empty?
          converted_name = convert(pagename)
          page = @book[converted_name]
          unless page.empty?
            return RedirectFormat.new(env, &block).redirect(page)
          end
        end
        super(req, env, &block)
      end

      def do_get_convert(req, env={}, &block)
        name = req.name
        name.sub!(/\A\#/, '')
        if /\Afoot(?:mark|note)-\d+(?:_\d+)?\z/ =~ name
          fragment = name
        else
          name.sub!(/\Aa(?=[^A-Za-z])/, '')
          name = ::RWiki::Encode.dot_decode(name)
          name = convert(name)
          fragment = ::RWiki::Encode.label2anchor(name)
        end
        return h(fragment) + "\n" + h(name)
      end

    end
  end

  Request::COMMAND << "convert"
end
