# -*- indent-tabs-mode: nil -*-
# lib/rwiki/xmlrpc/front.rb -- WikiRPC interface
#
# Copyright (c) 2004-2005 Kazuhiro NISHIYAMA
#
# You can redistribute it and/or modify it under the same terms as Ruby.

require 'rwiki/front'
require 'rwiki/rw-lib'
require 'xmlrpc/parser'

module RWiki
  Version.regist('rwiki/wikirpc/front', '$Id$')

  module WikiRPC
    module Support
      def wikirpc_front
        @wikirpc_front ||= WikiRPC::Front.new(@book)
      end
    end

    class Front
      def initialize(book)
        @book = book
      end

      def page(pagename)
        pagename = KCode.kconv(pagename)
        pg = @book[pagename]
        if pg.empty?
          raise XMLRPC::FaultException.new(1, "No such page was found.")
        end
        pg
      end
      private :page

      def page_info(pg)
        h = Hash.new
        h['name'] = KCode.to_utf8(pg.name)
        h['lastModified'] = pg.modified.utc
        author = pg.author and
          h['author'] = KCode.to_utf8(author)
        h['version'] = pg.int_version
        h
      end
      private :page_info

      # array getRecentChanges( Date timestamp )
      def getRecentChanges(timestamp)
        time = Time.utc(*timestamp.to_a)
        @book.recent_changes.select do |pg|
          pg.modified and time <= pg.modified
        end.collect do |pg|
          page_info(pg)
        end
      end

      # int getRPCVersionSupported()
      def getRPCVersionSupported
        2
      end

      # utf8 getPage( utf8 pagename )
      def getPage(pagename)
        KCode.to_utf8(page(pagename).src)
      end

      # utf8 getPageVersion( utf8 pagename, int version )
      def getPageVersion(pagename, version)
        pg = page(pagename)
        src = pg.src(pg.int_version_to_revision(version))
        KCode.to_utf8(src)
      end

      # utf8 getPageHTML( utf8 pagename )
      def getPageHTML(pagename, env)
        pg = page(pagename)
        env['static_view'] = true
        env['ref_name'] = env['full_ref_name'] = proc{|cmd, name, params|
          CGI.escape(name)
        }
        src = pg.static_view_html(env)
        KCode.to_utf8(src)
      end

      # utf8 getPageHTMLVersion( utf8 pagename, int version )
      def getPageHTMLVersion(pagename, version, env)
        raise NotImplementedError
        pg = page(pagename)
        env['static_view'] = true
        env['ref_name'] = env['full_ref_name'] = :underline_html
        env['rev'] = pg.int_version_to_revision(version)
        src = pg.static_view_html(env, &block)
        KCode.to_utf8(src)
      end

      # array getAllPages()
      def getAllPages
        @book.collect do |pg|
          KCode.to_utf8(pg.name)
        end
      end

      # struct getPageInfo( utf8 pagename )
      def getPageInfo(pagename)
        page_info(page(pagename))
      end

      # struct getPageInfoVersion( utf8 pagename, int version )
      def getPageInfoVersion(pagename, version)
        raise NotImplementedError
        page_info(page(pagename))
      end

      # array listLinks( utf8 pagename )
      def listLinks(pagename)
        pg = page(pagename)
        pg.hot_links.collect do |pg_name|
          {
            'page' => KCode.to_utf8(pg_name),
            'type' => 'local',
            #'href' => '',
          }
        end
      end

      # API ver2

      # array getBackLinks( utf8 page )
      def getBackLinks(pagename)
        pg = page(pagename)
        pg.hot_revlinks.collect do |pg_name|
          KCode.to_utf8(pg_name)
        end
      end

      # putPage( utf8 page, utf8 content, struct attributes )
      def putPage(pagename, content, attributes)
        pagename = KCode.kconv(pagename)
        pg = @book[pagename] # empty ok
        version = attributes['version'] and
          attributes[:revision] = pg.int_version_to_revision(version)
        attributes[:commit_log] ||= attributes['comment']
        pg.set_src(content, attributes[:revision]) do |key|
          attributes[key]
        end
        true
      end

      # array listAttachments( utf8 page )
      def listAttachments(pagename)
        [] # dummy
      end

      # base64 getAttachment( utf8 attachmentName )
      def getAttachment(attachmentName)
        XMLRPC::Base64.new('') # dummy
      end

      # putAttachment( utf8 attachmentName, base64 content )
      def putAttachment(attachmentName, content)
        false # dummy
      end
    end
  end
end
