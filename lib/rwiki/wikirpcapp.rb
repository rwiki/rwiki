# -*- indent-tabs-mode: nil -*-
# rwiki/xmlrpc.rb -- WikiRPC interface
#
# Copyright (c) 2004 Kazuhiro NISHIYAMA
#
# You can redistribute it and/or modify it under the same terms as Ruby.

require 'drb/drb'
require 'rwiki/rw-lib'

class RWikiRPC

  VERSION = ['rwiki/xmprpc', '2.1 ext']
  INTERPRETER_VERSION = ['ruby (WikiRPC interface)', "#{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"]

  def initialize(rwiki)
    @rwiki = rwiki
  end

  def get_env
    server_port = ENV['SERVER_PORT'] || '80'
    server_name = ENV['SERVER_NAME'] || 'localhost'
    env = Hash.new
    env[ 'base' ] = ENV[ 'SCRIPT_NAME' ] || 'rw-cgi.rb'
    env[ 'base_url' ] = RWiki::Request.base_url(ENV)
    env[ 'server' ] = server_name + ((server_port == '80') ? '' : ':' + server_port)
    env[ 'rw-agent-info' ] = [ VERSION, INTERPRETER_VERSION ]
    env
  end

  # array getRecentChanges( Date timestamp )
  def getRecentChanges(timestamp)
    time = Time.utc(*timestamp.to_a)
    @rwiki.recent_changes_info_utf8(time)
  end

  # int getRPCVersionSupported()
  def getRPCVersionSupported
    2
  end

  # utf8 getPage( utf8 pagename )
  def getPage(pagename)
    @rwiki.page_src_utf8(pagename) or
      raise raise XMLRPC::FaultException.new(1, "No such page was found.")
  end

  # utf8 getPageVersion( utf8 pagename, int version )

  # utf8 getPageHTML( utf8 pagename )
  def getPageHTML(pagename)
    @rwiki.page_html_utf8(pagename, get_env) {|key| nil } or
      raise raise XMLRPC::FaultException.new(1, "No such page was found.")
  end

  # utf8 getPageHTMLVersion( utf8 pagename, int version )

  # array getAllPages()
  def getAllPages
    @rwiki.all_pages_utf8
  end

  # struct getPageInfo( utf8 pagename )
  def getPageInfo(pagename)
    @rwiki.page_info_utf8(pagename) or
      raise raise XMLRPC::FaultException.new(1, "No such page was found.")
  end

  # struct getPageInfoVersion( utf8 pagename, int version )

  # array listLinks( utf8 pagename ):
  def listLinks(pagename)
    @rwiki.list_links_info_utf8(pagename) or
      raise raise XMLRPC::FaultException.new(1, "No such page was found.")
  end

  # array getBackLinks( utf8 page )
  def getBackLinks(pagename)
    @rwiki.list_revlinks_utf8(pagename) or
      raise raise XMLRPC::FaultException.new(1, "No such page was found.")
  end

  # putPage( utf8 page, utf8 content, struct attributes )
  # array listAttachments( utf8 page )
  # base64 getAttachment( utf8 attachmentName )
  # putAttachment( utf8 attachmentName, base64 content )
end
