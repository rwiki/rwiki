# -*- indent-tabs-mode: nil -*-

begin
  require "rwiki/gettext/available"
rescue LoadError
  require "rwiki/gettext/fallback"
end

module RWiki
  module GetText
    def _(msgid)
      msgid
    end

    def N_(msgid)
      msgid
    end

    def n_(msgid, msgid_plural, n)
      msgid
    end

    def s_(msgid, div = '|')
      msgid
    end
  end

  extend GetText
end
