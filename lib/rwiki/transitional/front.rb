# -*- indent-tabs-mode: nil -*-

require "rwiki/front"
require "rwiki/transitional/format"
require "iconv"

module RWiki
  module Transitional
    class Front < ::RWiki::Front

      def initialize(book, new_enc, old_enc)
        @book = book
        @new_enc = new_enc
        @old_enc = old_enc
      end

      private

      def do_get_view(req, env={}, &block)
        pagename = req.name
        page = @book[pagename]
        if page.empty?
          converted_name = Iconv.conv(@new_enc, @old_enc, pagename)
          page = @book[converted_name]
          unless page.empty?
            return RedirectFormat.new(env, &block).redirect(page)
          end
        end
        super(req, env, &block)
      end

    end
  end
end
