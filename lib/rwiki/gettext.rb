# -*- indent-tabs-mode: nil -*-

module RWiki
  module GetTextMixin
    def init_gettext(locales, available_locales)
      # do nothing
    end

    def locale
      nil
    end

    def _(msgid)
      msgid
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

  extend GetTextMixin
end
