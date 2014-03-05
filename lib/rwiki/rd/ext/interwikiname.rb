# -*- indent-tabs-mode: nil -*-

require 'erb'
require 'nkf'
require 'rwiki/gettext'
require 'rwiki/rd/ext/refer'

RWiki::Version.register('rwiki/rd/ext/interwikiname', '$Id$')

module RD
  module Ext
    class Refer
      CategoryRegexp = /\w+/

      def self.init_InterWikiName
        @@interwikinames = {}
        @@interwikinames_regexp = /(?!)/ # not match
      end
      init_InterWikiName

      def self.add_InterWikiName(category, uri, encoding=nil)
        unless /\A#{CategoryRegexp}\z/o =~ category
          raise sprintf(_("invalid character(s) in category: %s"), category)
        end
        @@interwikinames[category] = {
          :uri => uri,
          :encoding => encoding,
        }
        categories = @@interwikinames.keys.collect do |key|
          Regexp.quote(key)
        end.join('|')
        @@interwikinames_regexp = Regexp.compile(categories)
      end

      def ext_refer_InterWikiName(label, content, visitor)
        label = label.to_s
        return nil unless /^(#{@@interwikinames_regexp}):(.*)$/ =~ label
        category = $1
        wikiname = $2
        content = "[#{category}:#{wikiname}]" if label == content

        h = @@interwikinames[category]

        case h[:encoding]
        when 'euc'
          wikiname = u(NKF.nkf("-e -m0", wikiname))
        when 'sjis'
          wikiname = u(NKF.nkf("-s -m0", wikiname))
        when 'utf8'
          wikiname = u(NKF.nkf("-w -m0", wikiname))
        when 'raw', 'asis'
        when 'std'
          wikiname = u(wikiname)
        else
          wikiname = u(wikiname)
        end

        uri = h[:uri].dup
        unless uri.sub!(/\$1/, wikiname)
          uri.concat(wikiname)
        end

        visitor.url_ext_refer(uri, content)
      end
      def self.about_ext_refer_InterWikiName
        h(_("InterWikiName support"))
      end

    end # Refer
  end # Ext
end # RD
