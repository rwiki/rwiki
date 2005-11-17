# -*- indent-tabs-mode: nil -*-

require "erb"
require "iconv"
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
        name.gsub!(/((?:\.[0-9a-fA-F]{2})+)/n) do
          [$1.delete('.')].pack('H*')
        end
        name = convert(name)
        # see label2anchor() in lib/rwiki/rd/rd2rwiki-lib.rb
        fragment = name.gsub(/([^A-Za-z0-9\-_]+)/n) {
          '.' + $1.unpack('H2' * $1.size).join('.')
        }
        return h(fragment) + "\n" + h(name)
      end

    end
  end

  Request::COMMAND << "convert"
end
