# -*- indent-tabs-mode: nil -*-

begin
  require "rwiki/gettext/available"
rescue LoadError
  require "rwiki/gettext/fallback"
end

module RWiki

  module GetText
    def _(msgid)
      GetText.gettext(msgid)
    end

    def N_(msgid)
      msgid
    end
  end
    
  extend GetText
end
