# -*- indent-tabs-mode: nil -*-

require 'gettext'
require "thread"

module RWiki
  module GetText

    PATH = nil unless const_defined?(:PATH)

    class << self
      def make_gettext(locale=nil, charset=nil)
        locale ||= Locale.get
        ::GetText::TextDomain.new("rwiki", PATH, locale, charset)
      end
    end

    default = make_gettext
    @@gettexts = Hash.new(default)
    @@gettext = default
    @@mutex = Mutex.new

    class << self
      def set_locale(locale=nil)
        locale ||= Locale.get
        @@mutex.synchronize do
          if AVAILABLE_LOCALES.include?(locale)
            unless @@gettexts.has_key?(locale)
              gettext = make_gettext(locale)
              @@gettexts[locale] = gettext
            end
          else
            locale = nil
          end
          @@gettext = @@gettexts[locale]
        end
      end

      def set_charset(charset)
        @@mutex.synchronize do
          @@gettext.set_charset(charset)
        end
      end

      def gettext(msgid)
        @@gettext.gettext(msgid)
      end

      def ngettext(msgid, msgid_plural, n)
        @@gettext.ngettext(msgid, msgid_plural, n)
      end
      def sgettext(msgid, div = '|')
        @@gettext.sgettext(msgid, div)
      end
    end

    def _(msgid)
      GetText.gettext(msgid)
    end

    def N_(msgid)
      msgid
    end

    def n_(msgid, msgid_plural, n)
      GetText.ngettext(msgid, msgid_plural, n)
    end

    def s_(msgid, div = '|')
      GetText.sgettext(msgid, div)
    end

  end
end
