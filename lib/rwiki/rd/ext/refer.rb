# -*- indent-tabs-mode: nil -*-

require 'rwiki/rd/ext/base'
require 'rwiki/rd/ext/image'

module RD
  module Ext
    class Refer < Base
      include Image

      # For backward compatibility.
      def ext_refer_img(label, content, visitor)
        img(label, content, visitor)
      end
      def self.about_ext_refer_img
        h('for backward compatibility (example: ((<img:http://www.ruby-lang.org/image/title.gif>)))')
      end

      def ext_refer_quote(label, content, visitor)
        return nil unless /^quote:(.*)$/ =~ label.wikiname
        quoted_wikiname = $1
        quoted_label = RD::Reference::RWikiLabel.new(quoted_wikiname, label.anchor)
        content = quoted_label.to_s if label.to_s == content
        visitor.__send__(:default_ext_refer, quoted_label, content)
      end
      def self.about_ext_refer_quote
        h(%Q!for escape other extensions (example: ((<quote:info>)) link to this page)!)
      end

      def ext_refer_RubyML(label, content, visitor)
        label = label.to_s
        return nil unless /^(ruby-(?:core|talk|list|dev|math|ext)):\s*(\d+)$/ =~ label
        ml = $1
        article = $2.sub(/^0+/, '')
        content = "[#{label}]" if label == content
        url_ext_refer("http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/#{ ml }/#{ article }", content)
      end
      def self.about_ext_refer_RubyML
        h('ruby-core,talk,list,dev,math,ext (example:((<ruby-list:1>)))')
      end

      def ext_refer_RAA(label, content, visitor)
        label = label.to_s
        return nil unless /^RAA:\s*(.+)$/ =~ label
        name = CGI.escape($1)
        content = "[#{label}]" if label == content
        url_ext_refer("http://raa.ruby-lang.org/list.rhtml?name=#{ name }", content)
      end
      def self.about_ext_refer_RAA
        h('RAA 2.3.1 (example: ((<RAA:raa>)))')
      end

      RUBY_MAN_BASE = "http://www.ruby-lang.org/ja/man-1.6/"
      def ext_refer_rubyman(label, content, visitor)
        label = label.to_s
        return nil unless /^rubyman-1.6:\s*([^#]+)(?:#(.+))?$/ =~ label
        name, part = $1, $2
        name = CGI.escape(name)
        part = CGI.escape(part) if part
        content = "[#{label}]" if label == content
        url = RUBY_MAN_BASE + "?cmd=view;name=" + name
        url << '#' << part if part
        url_ext_refer(url, content)
      end
      def self.about_ext_refer_rubyman
        h('dev-rrr branch compatible feature (example: ((<rubyman-1.6:Object#class>)))')
      end

      def url_refer_freeml(ml, article, content)
        url_ext_refer(sprintf("http://www.freeml.com/message/%s@freeml.com/%07d",
                              ml, article.to_i),
                      content)
      end

      def ext_refer_FreeML(label, content, visitor)
        label = label.to_s
        return nil unless /^(rubyist|ap-(?:list|dev|ext|doc)):\s*(\d+)$/ =~ label
        content = "[#{label}]" if label == content
        url_refer_freeml($1, $2, content)
      end
      def self.about_ext_refer_FreeML
        h('rubyist, ap-{list,dev,ext,doc} (example: ((<rubyist:1>)))')
      end

      def ext_refer_ruby_cvs(label, content, visitor)
        label = label.to_s
        return nil unless /^ruby-cvs:\s*(.+)$/ =~ label
        file = CGI.escapeHTML($1)
        content = "[#{label}]" if label == content
        %Q[<a href="http://www.ruby-lang.org/cgi-bin/cvsweb.cgi/#{ file }">#{content}</a>]
      end
      def self.about_ext_refer_ruby_cvs
        h('Ruby CVS Repository (cvsweb) (example: ((<rd2rwiki-ext.rb of dev-rrr|ruby-cvs:app/rwiki/Attic/rd2rwiki-ext.rb?rev=1.3.2>)))')
      end

      def ext_refer_ruby_src(label, content, visitor)
        label = label.to_s
        return nil unless /^ruby-src:\s*(.+)$/ =~ label
        file = CGI.escapeHTML($1)
        content = "[#{label}]" if label == content
        %Q[<a href="http://www.ruby-lang.org/cgi-bin/cvsweb.cgi/ruby/#{ file }?rev=HEAD">#{content}</a>]
      end
      def self.about_ext_refer_ruby_src
        h('Ruby CVS Repository with revision (example: ((<ruby-src:version.h>)))')
      end

      def ext_refer_ruby_BTS(label, content, visitor)
        label = label.to_s
        return nil unless /^(ruby-bugs(?:-ja)?):(?:PR\#)?(\d+)$/ =~ label
        cgi, mid = $1, $2
        content = "[#{cgi}:PR##{mid}]" if label == content
        url_ext_refer("http://www.ruby-lang.org/cgi-bin/#{cgi}?selectid=#{mid}", content)
      end
      def self.about_ext_refer_ruby_BTS
        h('Ruby Bug Tracking System (JitterBug) (example: ((<ruby-bugs:1>)), ((<ruby-bugs-ja:1>)), ((<ruby-bugs-ja:PR#1>)))')
      end

      def ext_refer_RCR(label, content, visitor)
        label = label.to_s
        return nil unless /^RCR\#(\d+)$/ =~ label
        n = $1.to_i
        content = "[RCR\##{n}]" if label == content
        url_ext_refer("http://rcrchive.net/rcr/RCR/RCR#{n}", content)
      end
      def self.about_ext_refer_RCR
        h('RCR (Ruby Change Request) (example: ((<RCR#233>)))')
      end

      def ext_refer_ruby_win32ML(label, content, visitor)
        label = label.to_s
        return nil unless /^(ruby-win32):\s*(\d+)$/ =~ label
        ml = $1
        article = $2.sub(/^0+/, '')
        content = "[#{label}]" if label == content
        url_ext_refer("http://www.moonwolf.com/~arcml/cgi-bin/arcml/arcml.cgi?rm=view;list_id=1;ml_count=#{article}", content)
      end
      def self.about_ext_refer_ruby_win32ML
        h('ruby-win32 ML (example: ((<ruby-win32:1>)))')
      end

      RFC_SITE_BASE = 'http://ring.gr.jp/archives/doc/RFC/rfc%d.txt'
      # 'http://www.ietf.org/rfc/rfc%d'
      # 'http://www.ietf.org/rfc/rfc%d.txt'
      def ext_refer_RFC(label, content, visitor)
        label = label.to_s
        return nil unless /^(?:urn:ietf:)?rfc:\s*(\d+)$/i =~ label
        number = $1
        content = "RFC #{number}" if label == content
        url_ext_refer(sprintf(RFC_SITE_BASE, number), content)
      end
      def self.about_ext_refer_RFC
        h('RFC (example: ((<urn:ietf:rfc:1855>)), ((<RFC:2648>)))')
      end

      def ext_refer_rwiki_devel(label, content, visitor)
        label = label.to_s
        return nil unless /^(rwiki-devel):\s*(\d+)$/ =~ label
        ml = $1
        article = $2.sub(/^0+/, '')
        content = "[#{label}]" if label == content
        url_ext_refer("http://www.cozmixng.org/~w3ml/index.rb/rwiki-devel/msg/#{article}", content)
      end
      def self.about_ext_refer_rwiki_devel
        h('rwiki-devel ML (example: ((<rwiki-devel:1>)))')
      end

      private
      def url_ext_refer(url, content)
        %Q!<a href="<%= ref_url(#{url.to_s.dump}) %>">#{content}</a>!
      end

    end # Refer
  end # Ext
end # RD
