# -*- indent-tabs-mode: nil -*-
# rw-lib.rb
#
# Copyright (c) 2000-2001 Masatoshi SEKI
#
# rw-lib.rb is copyrighted free software by Masatoshi SEKI.
# You can redistribute it and/or modify it under the same term as Ruby.

require 'cgi'
require 'nkf'
require 'rwiki/encode'
require 'uri'
require 'webrick'

module Kernel
  unless methods.include?("funcall")
    def funcall(*args, &block)
      __send__(*args, &block)
    end
  end
end

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
      @list.each do |name, version|
        version = version.call if version.respond_to?(:call)
        yield(name, version)
      end
    end

    def regist(name, version=nil)
      version ||= Proc.new
      @list.push([name, version])
    end

    module_function :each, :regist
  end

  Version.regist('ruby (server side)',
                 "#{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]")

  module KCode
    attr_reader(:lang, :charset)

    def kconv(s)
      return '' unless s
      return s unless @nkf
      NKF.nkf(@nkf, s)
    end

    def to_utf8(s)
      return '' unless s
      return s unless @nkf
      NKF.nkf("-wdXm0", s)
    end

    def kcode(*args)
      case $KCODE
      when /^E/
        @lang = 'ja'
        @charset = 'euc-jp'
        @nkf = '-edXm0'
      when /^S/
        @lang = 'ja'
        @charset = 'Shift_JIS'
        @nkf = '-sdXm0'
      when /^U/
        @lang = "en"
        @charset = 'utf-8'
        @nkf = '-wdXm0'
      else
        @lang = "en"
        @charset = 'us-ascii'
        @nkf = nil
      end
    end

    private :kcode

    module_function :lang, :charset, :kconv, :kcode, :to_utf8
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
      @name = ::RWiki::Encode.name_unescape(@name)
    end

    def escape(string)
      ::RWiki::Encode.name_escape(string)
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

    def setup_response(response)
      unless header
        raise RuntimeError.new("Response header not set.")
      end
      header.setup_response(response)
      if body
        body.setup_response(response)
      else
        response.body = nil
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

      def setup_response(response)
        dump_items.each do |key, value|
          case key
          when 'status'
            response.status = value
          when 'content-type'
            response.content_type = value
          else
            response[key] = value
          end
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

        hash['status'] = @status

        if @type
          hash['content-type'] = @type
        else
          hash['content-type'] = "text/html"
        end
        hash['content-type'] += "; charset=#{@charset || KCode.charset}"
        if @size
          hash['content-length'] = @size
        else
          hash['connection'] = 'close'
        end
        hash['last-modified'] = last_modified if @date
        if @location and (300...400).include?(@status)
          hash['location'] = @location
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
      attr_reader :type, :charset, :date, :message

      def initialize(body, type='text/html', date=nil, charset=KCode.charset)
        @body = body
        @type = type
        @charset = charset
        @date = date
        @message = nil
        validate_body
      end

      GETA_KIGO = '&#x3013;'

      # substitude invalid chars to GETA KIGO.
      def validate_body
        if @body && /\b(?:html|xml)\b/ =~ @type
          @body.gsub!(/&\#(?:[xX]([A-Fa-f0-9]+)|(\d+));/) do
            if $1
              num = $1.to_i(16)
            elsif $2
              num = $2.to_i
            end
            case num
            when 0x9, 0xA, 0xD, 0x20..0xD7FF, 0xE000..0xFFFD, 0x10000..0x10FFFF
              $&
            else
              GETA_KIGO
            end
          end
          case $KCODE
          when 'UTF8'
            # [#x10000-#x10FFFF] are OK in XML 1.0 too
            @body.gsub!(/[^\x9\xA\xD\x20-\xD7FF\xE000-\xFFFD]/u) { GETA_KIGO }
          else
            @body.gsub!(/[\x0-\x8\xB\xC\xE-\x1F]/) { GETA_KIGO }
          end
        end
      end
      private :validate_body

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

      def setup_response(response)
        response.body = @body
      end
    end
  end
end
