# -*- indent-tabs-mode: nil -*-

module RWiki
  module GetText

    class << self
      def set_locale(locale=nil)
        # do nothing
      end

      def set_charset(charset)
        # do nothing
      end

      def gettext(msgid)
        msgid
      end

    end

    def _(msgid)
      GetText.gettext(msgid)
    end

    def N_(msgid)
      msgid
    end

    def n_(msgid, msgid_plural, n)
      if n == 1
        msgid
      else
        msgid_plural
      end
    end

    def s_(msgid, div = '|')
      if index = msgid.rindex(div)
        msgid = msgid[(index + 1)..-1]
      else
        msgid
      end
    end

  end
end
