# -*- indent-tabs-mode: nil -*-

begin
  require 'punycode'
rescue LoadError
end

module RWiki
  module Encode
    module_function

    def p_encode(string)
      if /\A[A-Za-z]+\z/ =~ string
        string
      else
        'p-' + Punycode.encode(string)
      end
    end

    def p_decode(string)
      if /\Ap-/ =~ string
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


    if defined?(::Punycode)
      def label2anchor(string)
        dot_encode(p_encode(string))
      end
      def name_escape(string)
        url_escape(p_encode(string))
      end
      alias name_unescape p_decode
    else
      alias label2anchor dot_encode
      alias name_escape url_escape
      def name_unescape(string)
        string
      end
    end
    module_function :label2anchor
    module_function :name_escape
    module_function :name_unescape
  end
end
