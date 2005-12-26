# -*- indent-tabs-mode: nil -*-

require 'rwiki/version'

module RWiki
  Version.regist('rwiki/encode', '$Id$')

  module Encode
    PunycodeMark = "p\x1a"
    module_function

    def p_encode(string)
      if /\A[\x20-\x7E]+\z/n =~ string
        string
      else
        PunycodeMark + Punycode.encode(string)
      end
    end

    def p_decode(string)
      if /\A#{Regexp.quote(PunycodeMark)}/on =~ string
        Punycode.decode($')
      else
        string
      end
    end

    def dot_encode(string)
      if /\A[A-Za-z]/ !~ string
        string = 'a' << string
      end
      string.gsub(/([^A-Za-z0-9\-_]+)/n) {
        '.' + $1.unpack('H2' * $1.size).join('.')
      }
    end

    def dot_decode(string)
      string.gsub(/((?:\.[0-9a-fA-F]{2})+)/n) do
        [$1.delete('.')].pack('H*')
      end
    end

    def url_escape(string)
      string.gsub(/([^ a-zA-Z0-9_.\-]+)/n) do
        '%' + $1.unpack('H2' * $1.size).join('%').upcase
      end.tr(' ', '+')
    end

    GETA_KIGO = '&#x3013;'

    # substitude invalid chars to GETA KIGO.
    def geta_escape!(xml)
      xml.gsub!(/&\#(?:[xX]([A-Fa-f0-9]+)|(\d+));/) do
        if $1
          num = $1.to_i(16)
        elsif $2
          num = $2.to_i
        end
        case num
        when 0x9, 0xA, 0xD, 0x20..0xD7FF, 0xE000..0xFFFD, 0x10000..0x10FFFF
          $&
        else
          GETA_KIGO
        end
      end
      case $KCODE
      when 'UTF8'
        # [#x10000-#x10FFFF] are OK in XML 1.0 too
        xml.gsub!(/[^\x9\xA\xD\x20-\xD7FF\xE000-\xFFFD]/u) { GETA_KIGO }
      else
        xml.gsub!(/[\x0-\x8\xB\xC\xE-\x1F]/) { GETA_KIGO }
      end
      xml
    end

    def geta_escape(xml)
      geta_escape!(xml.dup)
    end

    def self.__undef_methods
      module_eval do
        if defined?(label2anchor)
          undef_method :label2anchor
          undef_method :name_escape
          undef_method :name_unescape
        end
      end
    end
    def self.__module_functions
      module_eval do
        module_function :label2anchor
        module_function :name_escape
        module_function :name_unescape
      end
    end

    def self.no_punycode
      __undef_methods
      module_eval do
        alias label2anchor dot_encode
        alias name_escape url_escape
        def name_unescape(string)
          string
        end
      end
      __module_functions
    end

    def self.use_punycode
      require 'punycode'
      __undef_methods
      module_eval do
        def label2anchor(string)
          dot_encode(p_encode(string))
        end
        def name_escape(string)
          url_escape(p_encode(string))
        end
        alias name_unescape p_decode
      end
      __module_functions
    end

    no_punycode # default
  end
end
