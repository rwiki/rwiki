# -*- indent-tabs-mode: nil -*-
# rw-lib.rb
#
# Copyright (c) 2000-2001 Masatoshi SEKI
#
# rw-lib.rb is copyrighted free software by Masatoshi SEKI.
# You can redistribute it and/or modify it under the same term as Ruby.

require 'nkf'
require 'uri'
require 'cgi'

require 'webrick/httputils'

module RWiki
  class RWikiError < RuntimeError; end
  class InvalidRequest < RWikiError; end
  class UnknownCommand < InvalidRequest; end
  class RevisionError < RWikiError; end
  class RWikiNameError < RWikiError; end
  class RWikiNameTooLongError < RWikiNameError; end
  
  module Version
    @list = []
    
    def each 
      @list.each do |v|
        yield(v[0], v[1])
      end
    end
    
    def regist(mod, ver)
      @list.push([mod, ver])
    end
    
    module_function :each, :regist
  end
  
  Version.regist('ruby (server side)', "#{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]")
  
  module KCode
    attr_reader(:lang, :charset)
    
    def kconv(s)
      return '' unless s
      return s unless @nkf
      NKF.nkf(@nkf, s)
    end
    
    def kcode(*args)
      case $KCODE
      when /^[Ee]/
        @lang = 'ja'
        @charset = 'euc-jp'
        @nkf = '-edXm0'
      when /^[Ss]/
        @lang = 'ja'
        @charset = 'Shift_JIS'
        @nkf = '-sdXm0'
      else
        @lang = "en"
        @charset = 'us-ascii'
        @nkf = nil
      end
    end
    
    private :kcode
    
    module_function :lang, :charset, :kconv, :kcode
    kcode()
    trace_var(:$KCODE, method(:kcode))
  end
  
  class Request
    COMMAND = %w(view edit submit src)
    
    def self.parse(cgi, do_validate=true)
      cmd ,= cgi['cmd']
      name ,= cgi['name']
      rev ,= cgi['rev']
      src ,= cgi['src']
      src = KCode.kconv(src) if src
      new(cmd, name, src, rev, do_validate)
    end
    
    def self.default_url(env)
      home = new( 'view', RWiki::TOP_NAME )
      base_url(env) + "?" + home.query
    end

    def self.base(env)
      request_uri = env['REQUEST_URI']
      script_name = env['SCRIPT_NAME'] || 'rw-cgi.rb'
      if request_uri
        path = URI.parse(request_uri).path
        path = nil if /\A\s*\z/ =~ path
      end
      path or script_name
    end
    
    def self.base_url(env)
      return env['base_url'] if env['base_url']
      
      server_name = env['SERVER_NAME']
      server_port = env['SERVER_PORT']
      if /on/i =~ env['HTTPS']
        scheme = "https"
        default_port = '443'
      else
        scheme = "http"
        default_port = '80'
      end
      build_uri(scheme, server_name, server_port, default_port, base(env))
    end

    def self.build_uri(scheme, name, actual_port, default_port, path)
      port = (actual_port == default_port) ? '' : ":#{actual_port}"
      "#{scheme}://#{name}#{port}#{path}"
    end
    
    def initialize(cmd, name=nil, src=nil, rev=nil, do_validate=true)
      @cmd = cmd
      @name = name
      @src = src
      @rev = rev
      validate if do_validate
    end
    attr_reader :cmd, :name, :src, :rev
    
    def query
      "cmd=#{@cmd};name=#{escape(@name)}"
    end
    
    def inspect
      "cmd: #{ @cmd }, name: #{ @name }, rev: #{ @rev }, src: #{ @src }"
    end
    
    def validate
      validate_command
      validate_name
    end
    
    private
    def validate_command
      raise UnknownCommand, @cmd.inspect unless @cmd
      raise UnknownCommand, @cmd.inspect unless COMMAND.include? @cmd
    end
    
    def validate_name
      raise InvalidRequest unless @name
    end
    
    def escape( string )
      string.gsub(/([^ a-zA-Z0-9_.\-]+)/n) do
        '%' + $1.unpack('H2' * $1.size).join('%').upcase
      end.tr(' ', '+')
    end
  end
  

  class Response

    def initialize(header=nil, body=nil)
      self.header = header
      self.body = body
    end

    def dump
      unless header
        raise RuntimeError.new("Response header not set.")
      end
      str = header.dump
      str << body.dump.to_s if body
      str
    end

    def setup_context(context)
      unless header
        raise RuntimeError.new("Response header not set.")
      end
      header.setup_context(context)
      if body
        body.setup_context(context)
      else
        context.res_body("")
      end
    end
    
    def header
      @header
    end

    def header=(header)
      @header = header
      sync
    end

    def body
      @body
    end

    def body=(body)
      @body = body
      sync
    end

    private
    def sync
      if @header and @body
        @header.type = body.type
        @header.charset = body.charset
        @header.size = body.size
        @header.date = body.date
      end
    end
    
    class Header
      attr_accessor :status, :type, :charset, :size, :date, :location

      CRLF = "\r\n"
      
      STATUS_MAP = {
        200 => 'OK',
        302 => 'Object moved',
        304 => 'Not Modified',
        400 => 'Bad Request',
        500 => 'Internal Server Error',
        503 => 'Service Unavailable'
      }

      CHARSET_MAP = {
        'NONE' => 'us-ascii',
        'EUC' => 'euc-jp',
        'SJIS' => 'shift_jis',
      }

      def initialize(status=200)
        @status = status
        @type = nil
        @charset = nil
        @size = nil
        @date = nil
        @location = nil
        @extra = []
      end

      def add(key, value)
        @extra.push([key, value])
      end

      def setup_context(context)
        dump_items.each do |key, value|
          context.res_header(key, value)
        end
      end

      def dump
        dump_items.collect do |key, value|
          "#{key}: #{value}"
        end.join(CRLF) + CRLF
      end

      def [](key)
        result = @extra.assoc(key)
        if result
          result[1]
        else
          nil
        end
      end

      private
      def dump_items
        hash = {}

        str = ''
        @status = 400 unless STATUS_MAP.has_key?(@status)

        hash['status'] = @status.to_s

        if @type
          hash['content-type'] = @type
        else
          hash['content-type'] = "text/html"
        end
        hash['content-type'] += "; charset=#{@charset || CHARSET_MAP[$KCODE]}"
        if @size
          hash['content-length'] = @size
        else
          hash['connection'] = 'close'
        end
        hash['Last-Modified'] = last_modified if @date
        if @location and (300...400).include?(@status)
          hash['Location'] = @location
        end
        
        @extra.each do |key, value|
          hash[key] = value
        end
        hash
      end

      def to_cgi_status(number)
        pattern = /^#{number} /
        CGI::HTTP_STATUS.each do |key, value|
          return key if pattern =~ value
        end
        "BAD_REQUEST"
      end

      def last_modified
        CGI.rfc1123_date(@date)
      end
    end

    class Body
      attr_accessor :type, :charset, :date, :message

      def initialize(body=nil, date=nil, type=nil, charset=nil)
        @body = body
        @type = type
        @charset = charset
        @date = date
        @message = nil
      end

      def size
        if @body
          @body.size
        else
          nil
        end
      end

      def dump
        @body
      end

      def setup_context(context)
        context.res_body(@body.to_s)
      end
    end
  end
end
