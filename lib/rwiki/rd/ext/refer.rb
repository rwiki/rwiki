# -*- indent-tabs-mode: nil -*-

require 'rwiki/gettext'
require 'rwiki/rd/ext/base'
require 'rwiki/rd/ext/image'

module RD
  module Ext
    class Refer < Base
      include RWiki::GetTextMixin

      def ext_refer_quote(label, content, visitor)
        return nil unless /^quote:(.*)$/ =~ label.wikiname
        quoted_wikiname = $1
        quoted_label = RD::Reference::RWikiLabel.new(quoted_wikiname, label.anchor)
        content = quoted_label.to_s if label.to_s == content
        visitor.__send__(:default_ext_refer, quoted_label, content)
      end
      def self.about_ext_refer_quote
        h(_("for escape other extensions (example: ((<quote:info>)) link to this page)"))
      end

      def ext_refer_RubyML(label, content, visitor)
        label = label.to_s
        return nil unless /^(ruby-(?:core|talk|list|dev|math|ext)):\s*(\d+)$/ =~ label
        ml = $1
        article = $2.sub(/^0+/, '')
        content = "[#{label}]" if label == content
        visitor.url_ext_refer("http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/#{ ml }/#{ article }", content)
      end
      def self.about_ext_refer_RubyML
        h(_('ruby-core,talk,list,dev,math,ext (example:((<ruby-list:1>)))'))
      end

      def ext_refer_RAA(label, content, visitor)
        label = label.to_s
        return nil unless /^RAA:\s*(.+)$/ =~ label
        uri = "http://raa.ruby-lang.org/project/#{h($1)}"
        content = "[#{label}]" if label == content
        visitor.url_ext_refer(uri, content)
      end
      def self.about_ext_refer_RAA
        h(_('RAA 2.3.1 (example: ((<RAA:raa>)))'))
      end

      RUBY_MAN_BASE = "http://www.ruby-lang.org/ja/man/"
      def ext_refer_rubyman(label, content, visitor)
        label = label.to_s
        return nil unless /^rubyman(?:-1.6)?:\s*([^#]+)(?:#(.+))?$/ =~ label
        name, part = $1, $2
        name = CGI.escape(name)
        part = CGI.escape(part) if part
        content = "[#{label}]" if label == content
        url = RUBY_MAN_BASE + "?cmd=view;name=" + name
        url << '#' << part if part
        visitor.url_ext_refer(url, content)
      end
      def self.about_ext_refer_rubyman
        h(_('dev-rrr branch compatible feature (example: ((<rubyman-1.6:Object#class>)) or ((<rubyman:Object#class>)))'))
      end

      def url_refer_freeml(ml, article, content, visitor)
        format = "http://www.freeml.com/message/%s\@freeml.com/%07d"
        uri = sprintf(format, ml, article.to_i)
        visitor.url_ext_refer(uri, content)
      end

      def ext_refer_FreeML(label, content, visitor)
        label = label.to_s
        return nil unless /^(rubyist|ap-(?:list|dev|ext|doc)):\s*(\d+)$/ =~ label
        content = "[#{label}]" if label == content
        url_refer_freeml($1, $2, content, visitor)
      end
      def self.about_ext_refer_FreeML
        h(_('rubyist, ap-{list,dev,ext,doc} (example: ((<rubyist:1>)))'))
      end

      def url_refer_atdot_w3ml(ml, article, content, visitor)
        uri = "http://www.atdot.net/~ko1/w3ml/w3ml.cgi/#{ml}/msg/#{article.to_i}"
        visitor.url_ext_refer(uri, content)
      end

      def ext_refer_atdot_w3ml(label, content, visitor)
        label = label.to_s
        return nil unless /^(yarv-dev|ruby-eng):\s*(\d+)$/ =~ label
        content = "[#{label}]" if label == content
        url_refer_atdot_w3ml($1, $2, content, visitor)
      end
      def self.about_ext_refer_atdot_w3ml
        h(_('yarv-dev, ruby-eng (example: ((<yarv-dev:1>)))'))
      end

      def ext_refer_ruby_cvs(label, content, visitor)
        label = label.to_s
        content = "[#{label}]" if label == content
        if /^(ruby-cvs):\s*(\d+)$/ =~ label
          return url_refer_atdot_w3ml($1, $2, content, visitor)
        end
        return nil unless /^ruby-cvs:\s*(.+)$/ =~ label
        file = CGI.escapeHTML($1)
        #visitor.url_ext_refer("http://www.ruby-lang.org/cgi-bin/cvsweb.cgi/#{file}", content)
        visitor.url_ext_refer("http://svn.ruby-lang.org/cgi-bin/viewvc.cgi/#{file}", content)
      end
      def self.about_ext_refer_ruby_cvs
        h(_('Ruby SVN Repository (viewvc) or ruby-cvs ML (example: ((<README.ja of trunk rev.11800|ruby-cvs:trunk/README.ja?revision=11800>)) or ((<ruby-cvs:16000>)))'))
      end

      def ext_refer_ruby_src(label, content, visitor)
        label = label.to_s
        return nil unless /^ruby-src:\s*(.+)$/ =~ label
        file = CGI.escapeHTML($1)
        content = "[#{label}]" if label == content
        #visitor.url_ext_refer("http://www.ruby-lang.org/cgi-bin/cvsweb.cgi/ruby/#{ file }?rev=HEAD", content)
        visitor.url_ext_refer("http://svn.ruby-lang.org/cgi-bin/viewvc.cgi/trunk/#{file}?view=co", content)
      end
      def self.about_ext_refer_ruby_src
        h(_('Ruby SVN Repository with HEAD revision of trunk (example: ((<ruby-src:version.h>)))'))
      end

      def ext_refer_ruby_BTS(label, content, visitor)
        label = label.to_s
        return nil unless /^(ruby-bugs(?:-ja)?):(?:PR\#)?(\d+)$/ =~ label
        cgi, mid = $1, $2
        if label == content
          h("[#{cgi}:PR\##{mid}]")
        else
          h("#{content}[#{cgi}:PR##{mid}]")
        end
      end
      def self.about_ext_refer_ruby_BTS
        h(_('Ruby Bug Tracking System (JitterBug) (not found now) (example: ((<ruby-bugs:1>)), ((<ruby-bugs-ja:1>)), ((<ruby-bugs-ja:PR#1>)))'))
      end

      RUBY_TRACKER_BASE = "http://rubyforge.org/tracker/"
      RUBY_TRACKER_TYPES = {
        "Bugs" => 1698,
        "Requests" => 1699,
        "Patches" => 1700,
      }
      ruby_tracker_types_re = RUBY_TRACKER_TYPES.keys.join("|")
      RUBY_TRACKER_RE = /^(ruby-(#{ruby_tracker_types_re})):(?:\#)?(\d+)$/
      def ext_refer_ruby_tracker(label, content, visitor)
        label = label.to_s
        return nil unless RUBY_TRACKER_RE =~ label
        name, type, aid = $1, $2, $3
        content = "[#{name}:##{aid}]" if label == content
        params = {
          "func" => "detail",
          "group_id" => 426,
          "aid" => aid,
          "atid" => RUBY_TRACKER_TYPES[type],
        }.collect {|k, v| "#{k}=#{v}"}.join('&')
        visitor.url_ext_refer("#{RUBY_TRACKER_BASE}?#{params}", content)
      end
      def self.about_ext_refer_ruby_tracker
        h(_('Ruby Tracker (RubyForge) (example: ((<ruby-Bugs:1>)), ((<ruby-Requests:1>)), ((<ruby-Patches:1>)))'))
      end

      def ext_refer_RCR(label, content, visitor)
        label = label.to_s
        return nil unless /^RCR\#(\d+)$/ =~ label
        n = $1.to_i
        content = "[RCR\##{n}]" if label == content
        visitor.url_ext_refer("http://rcrchive.net/rcr/show/#{n}", content)
      end
      def self.about_ext_refer_RCR
        h(_('RCR (Ruby Change Request) (example: ((<RCR#233>)))'))
      end

      def ext_refer_ruby_win32ML(label, content, visitor)
        label = label.to_s
        return nil unless /^(ruby-win32):\s*(\d+)$/ =~ label
        ml = $1
        article = $2.sub(/^0+/, '')
        # content = "[#{label}]" if label == content
        # visitor.url_ext_refer("http://www.moonwolf.com/~arcml/cgi-bin/arcml/arcml.cgi?rm=view;list_id=1;ml_count=#{article}", content)
        if label == content
          h("[#{label}]")
        else
          h("#{content}[ruby-win32:#{article}]")
        end
      end
      def self.about_ext_refer_ruby_win32ML
        h(_('ruby-win32 ML (not found now) (example: ((<ruby-win32:1>)))'))
      end

      RFC_SITE_BASE = 'http://www.ring.gr.jp/archives/doc/RFC/rfc%d.txt'
      # 'http://www.ietf.org/rfc/rfc%d'
      # 'http://www.ietf.org/rfc/rfc%d.txt'
      def ext_refer_RFC(label, content, visitor)
        label = label.to_s
        return nil unless /^(?:urn:ietf:)?rfc:\s*(\d+)$/i =~ label
        number = $1
        content = "RFC #{number}" if label == content
        visitor.url_ext_refer(sprintf(RFC_SITE_BASE, number), content)
      end
      def self.about_ext_refer_RFC
        h(_('RFC (example: ((<urn:ietf:rfc:1855>)), ((<RFC:2648>)))'))
      end

      def ext_refer_rwiki_devel(label, content, visitor)
        label = label.to_s
        return nil unless /^(rwiki-devel):\s*(\d+)$/ =~ label
        ml = $1
        article = $2.sub(/^0+/, '')
        content = "[#{label}]" if label == content
        visitor.url_ext_refer("http://www.cozmixng.org/~w3ml/index.rb/rwiki-devel/msg/#{article}", content)
      end
      def self.about_ext_refer_rwiki_devel
        h(_('rwiki-devel ML (example: ((<rwiki-devel:1>)))'))
      end

    end # Refer
  end # Ext
end # RD
