#!/usr/local/bin/ruby

# rw-mail.rb -- RWiki mail interface.
#
# Copyright (c) 2000, 2001 Masatoshi SEKI and NAKAMURA, Hiroshi
#
# rw-mail.rb is copyrighted free software by Masatoshi SEKI and NAKAMURA, Hiroshi.
# You can redistribute it and/or modify it under the same terms as Ruby.


# Usage:
#
#   Add new entry to /etc/aliases(if you can) or your .forward(if this works).
#     "|( cd /path-to-rw-mail.rb-directory && ./rw-mail.rb RWikiURI FROM )"
#
#   'RWikiURI' is a RWiki server endpoint.  dRuby URI format like
#   'druby://localhost:8470'.  'FROM' is the mail account of the program used
#   to identify the sender in SMTP.


# SYNOPSIS
#   SCMail.new( arg, dest = nil )
#
# ARGS
#   arg		'String' of full mail text.
#		  or
#		'SCMail' of another instance.
#
# DESCRIPTION
#   Maintains a mail.
#   If arg is_a 'String', arg is parsed to set @header and @body.
#   If arg is_a 'SCMail', only significant headers of arg are copied to
#     new instance. So you must set other headers and body for the mail.
#
require 'kconv'
class SCMail
  attr( :header, true )
  attr( :body, true )
  attr( :from, true )
  attr( :dest, true )

  # SYNOPSIS
  #   addHeader( attr, value )
  #
  # ARGS
  #   attr	String of attribute to add.
  #   value	String of value of the attribute.
  #
  # DESCRIPTION
  #   Add specified header.
  #
  public
  def addHeader( attr, value )
    @header.push( [attr, value] )
  end

  # SYNOPSIS
  #   removeHeader( attr )
  #
  # ARGS
  #   attr	String of attribute to remove.
  #
  # DESCRIPTION
  #   Remove specified header.
  #
  public
  def removeHeader( attr )
    newHeader = []
    nofRemove = 0
    @header.each do |h|
      if ( attr.downcase == h[0].downcase )
	nofRemove += 1
      else
	newHeader.push( h )
      end
    end
    @header = newHeader
    nofRemove
  end

  # SYNOPSIS
  #   searchHeader( attr )
  #
  # ARGS
  #   attr	String of attribute to search.
  #
  # DESCRIPTION
  #   Search specified header.
  #
  # RETURN
  #   Array of found headers.
  #
  public
  def searchHeader( attr )
    value = []
    @header.each do |h|
      if ( attr.downcase == h[0].downcase )
	value.push( h[1] )
      end
    end
    value
  end

  # SYNOPSIS
  #   dumpHeader()
  #
  # DESCRIPTION
  #   Dump the mail header. Attribute and value are joined with ': ',
  #   and each header is joined with CRLF.
  #
  # RETURN
  #   String of the mail header.
  #
  public
  def dumpHeader()
    str = ""
    line = ""
    for i in @header do
      line = i.join( ": " )
      str << line << CRLF
    end
    str
  end

  # SYNOPSIS
  #   dump()
  #
  # DESCRIPTION
  #   Dump the mail. Header part and body are joined with CRLF.
  #   See dumpHeader() for header part format.
  #
  # RETURN
  #   String of the mail.
  #
  public
  def dump()
    dumpHeader() << CRLF << Kconv::kconv( @body, Kconv::JIS, Kconv::AUTO )
  end

  # SYNOPSIS
  #   loop?( str )
  #
  # DESCRIPTION
  #   Check the mail loops.
  #   Check the 'LoopHeader' header of this mail, and compare the header
  #	with 'str'.
  #   Calling this method causes adding new header for detecting
  #	the mail loop next time.
  #
  # RETURN
  #   true if mail loop detected.
  #
  public
  def loop?( sysName )
    if ( searchHeader( LoopHeader ).include?( sysName ))
      return true
    else
      addHeader( LoopHeader, sysName )
      return false
    end
  end

  # SYNOPSIS
  #   deepDup()
  #
  # DESCRIPTION
  #   Create and deep-copy the given SCMail.
  #
  # RETURN
  #   Duplicated new instance.
  #
  public
  def deepDup()
    newMail = SCMail.new()
    newMail.header = self.header.dup if self.header
    newMail.body = self.body.dup if self.body
    newMail.from = self.from.dup if self.from
    newMail.dest = self.dest.dup if self.dest
    newMail
  end

  # SYNOPSIS
  #   SCMail.parseAddress()
  #
  # DESCRIPTION
  #   Parse 'From' line and split it into E-mail and name.
  #   Parsed name is nil if not given.
  #
  # RETURN
  #   E-mail addr. and name.
  #
  public
  def SCMail.parseAddress( str )
    name = nil
    addr = nil
    if /^"([^"]*)"\s*<([^>][^>]*)>$/ =~ str
      # From: "NaHi" <nahi@keynauts.com>
      name = $1; addr = $2;
    elsif ( str =~ /^([^<]*)\s*<([^>][^>]*)>$/ )
      # From: NaHi <nahi@keynauts.com>
      name = $1; addr = $2;
    elsif ( str =~ /^([^(][^(]*)\s*\(([^)]*)\)$/ )
      # From: nahi@keynauts.com (NaHi)
      name = $2; addr = $1;
    else
      # From: nahi@keynauts.com
      name = nil; addr = str.dup;
    end
    return addr, name
  end

  private

  CRLF = "\r\n"
  LoopHeader = "X-RWikiMailApp-Loop"

  def initialize( arg = nil, dest = nil )
    @header = []
    @body = ""
    @from = ""
    @dest = dest
    if ( arg )
      if ( arg.is_a?( SCMail ))
      	arg.searchHeader( LoopHeader ).each do |value|
      	  addHeader( LoopHeader, value )
      	end
      	@from = arg.from
      else
      	parse( arg )
      end
    end
  end

  def parse( s )
    status = "HEADER"

    attr = ""
    value = ""

    while s.gets
      case status
      when "HEADER"
	if ( /^$/ )
	  status = "BODY"
	elsif ( $_.sub!( /^\s+/, "" ))
	  value << " " << $_
	else
	  if ( attr != "" )
	    value.chomp!
	    addHeader( attr, value )
	  end
	  attr, value = $_.split( /:\s*/, 2 );
	end

      when "BODY"
	@body << $_

      end
    end
    if ( attr != "" )
      value.chomp! if value
      addHeader( attr, value )
    end

    @body = Kconv::kconv( @body, Kconv::EUC, Kconv::AUTO )
    self
  end
end


# SYNOPSIS
#   RWikiMailApp.new( rwikiURI, from )
#
# ARGS
#   rwikiURI	RWiki server endpoint.
#   from	From.
#
# DESCRIPTION
#
require 'application'
require 'rw-desc.rb'
require 'drb/drb'
require 'net/smtp.rb'
class RWikiMailApp < Application
  include Log::Severity
  include Net

  public

  def initialize( rwikiURI, from )
    super( AppName )
    setLog( File.join( 'log', ( AppName.dup << ".log" )), ShiftAge, ShiftSize )
    @sysName = AppName
    @rwikiURI = rwikiURI
    @from = from
  end

  private

  class Request
    attr_reader :cmd, :name, :src

    def initialize( cmd = nil, name = nil, src = nil )
      @cmd = cmd
      @name = name
      setSrc( src )
    end

    # REQUIRE: subject is EUC encoded.
    def parsePath( subject )
      if /^([^\/]+)\/@?(.+)$/e =~ subject
        @cmd = $1
        @name = $2
      end
    end

    # REQUIRE: mailBody should begin with 'RWiki'.  Ignore if it does not.
    def setSrc( mailBody )
      desc = RWikiDescRDMail.parse( mailBody )
      @src = desc.body
    end

    def inspect
      "cmd: #{ @cmd }, name: #{ @name }, src: #{ @src }"
    end
  end

  AppName = 'RWikiMailApp'
  ShiftAge = 'weekly'
  ShiftSize = nil

  def run()
    begin
      # Check arguments.
      if ( !@rwikiURI )
        log( SEV_FATAL, "RWiki server endpoint not set." )
	return 0
      end

      if ( !@from )
	log( SEV_FATAL, "SMTP sender not set." )
	return 0
      end

      @mail = SCMail.new( STDIN )
      log( SEV_INFO, "A mail arrived from '#{ @mail.searchHeader( \"from\" )[0] }' to '#{ @mail.searchHeader( \"to\" )[0] }'." )

      # Check loop mail.
      if ( @mail.loop?( @sysName ))
      	log( SEV_WARN, "Loop detected. Exiting..." )
      	return 0
      end

      req = parseRequest()
      if !req.cmd or !req.name
        log( SEV_INFO, "Parsing subject failed.  Noop." )
	return 0
      elsif !req.src
        log( SEV_WARN, "Body must begin with 'RWiki'.  Noop." )
	return 0
      end
      res = connectRWiki( req )
      sendResult( req, res )

    rescue
      log( SEV_FATAL, "Detected an exception. Stopping ... #{ $! } (#{ $!.type })\n" << $@.join( "\n" ))
    end

    # Any mailer should not return the status 'non-0'.
    return 0
  end

  def parseRequest
    # Kconv converts base64 to raw data.
    subject = @mail.searchHeader( 'subject' )[0] || ""
    subject = Kconv.kconv( subject, Kconv::EUC, Kconv::AUTO )
    log( SEV_INFO, "Subject line: '#{ subject }'." )
    req = Request.new
    req.parsePath( subject )
    req.setSrc( @mail.body )
    log( SEV_INFO, "Request: '#{ req.inspect }'." )
    return req
  end

  def connectRWiki( req )
    DRb.start_service()
    rwiki = DRbObject.new( nil, @rwikiURI )

    log( SEV_INFO, 'Connecting to RWiki...' )

    response = nil

    case req.cmd
    when 'view'
      page = rwiki.page( req.name )
      response = page.view_html( getEnv ) { |key| '' }
    when 'src'
      page = rwiki.page( req.name )
      src = page.src
      desc = RWikiDescRDMail.new( src )
      response = desc.retrieve
    when 'update'
      page = rwiki.page( req.name )
      page.src = req.src
      response = page.src
    when 'delete'
      page = rwiki.page( req.name )
      page.src = ''
      response = page.src
    else
      raise RuntimeError.new( "Unknown command: '#{ req.cmd }'." )
    end

    log( SEV_INFO, "...done.  Response:\n#{ response }." )
    return response
  end

  def getEnv
    env = Hash.new
    env[ 'base' ] = "mailto:#{ @from }"
#    env[ 'ref_name' ] = Proc.new { |cmd, name|
#	"mailto:#{ @from }?subject=#{ cmd }/#{ name }"
#      }
    env
  end

  def sendResult( req, res )
    case req.cmd
    when 'view'
      sendBackMail( 'View', "Viewing '#{ req.name }'.\n\n#{ res }" )
    when 'src'
      sendBackMail( 'Source', "Source of '#{ req.name }':\n\n#{ res }" )
    when 'update'
      sendBackMail( 'Updated', "Updated '#{ req.name }'.\n\n#{ res }" )
    when 'delete'
      sendBackMail( 'Deleted', "Deleted '#{ req.name }'.\n\ndeleted." )
    else
      raise RuntimeError.new( "Unknown command: '#{ req.cmd }'." )
    end
  end

  def sendBackMail( subject, body )
    aMail = SCMail.new( @mail )
    reciptMail, reciptName = SCMail.parseAddress( @mail.searchHeader( "from" )[ 0 ] )
    aMail.dest = [ reciptMail ]
    aMail.from = @from
    aMail.addHeader( "To", reciptMail )
    aMail.addHeader( "From", @from )
    aMail.addHeader( "Date", RWikiMailApp.mailDate( Time.now ))
    aMail.addHeader( "Subject", subject )
    aMail.body = body

    doSendMail( aMail )
  end

  def doSendMail( aMail )
    if ( $DEBUG )
      log( SEV_DEBUG, "(doSendMail) In debug mode. The mail was not sent." )
      log( SEV_DEBUG, "(doSendMail) Message: " << aMail.dump() )
      return
    end
    if ( !aMail.dest )
      log( SEV_WARN, "(doSendMail) Destination not found..." )
      return
    end
    log( SEV_INFO, "(doSendMail) Sending to #{ aMail.dest.size } recipient(s)..." )
    begin
      SMTP::start( "localhost", 25, "localhost" ) do |ses|
      	ses.sendmail( aMail.dump(), aMail.from, aMail.dest )
      end
    rescue
      log( SEV_ERROR, "(doSendMail) An error occurred in SMTP lib. #{ $! } (#{ $!.type })\n" << $@.join( "\n" ))
    end
  end

  def RWikiMailApp.mailDate( aTime )
    aTime.gmtime.strftime( "%a, %d %b %Y %H:%M:%S GMT" )
  end
end

RWikiURI = ARGV.shift
From = ARGV.shift

app = RWikiMailApp.new( RWikiURI, From ).start()
exit 0

