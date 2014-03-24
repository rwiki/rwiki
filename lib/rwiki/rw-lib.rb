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

  class Request
    COMMAND = %w(view edit submit src)

    def self.normalize(str)
      return nil unless str
      str = str.encode('utf-8', 'utf-8', :universal_newline => true)
      raise InvalidRequest unless str.valid_encoding?
      str
    end

    def self.parse(cgi, do_validate=true)
      cmd ,= cgi['cmd']
      name ,= cgi['name']
      rev ,= cgi['rev']
      src ,= cgi['src']
      name = normalize(name)
      src = normalize(src)
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
      sync
      @header
    end

    def header=(header)
      @header = header
    end

    def body
      @body
    end

    def body=(body)
      @body = body
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
        404 => 'Forbidden',
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

        @status = 400 unless STATUS_MAP.has_key?(@status)

        hash['status'] = @status

        if @type
          hash['content-type'] = @type
        else
          hash['content-type'] = "text/html"
        end
        hash['content-type'] += "; charset=#{@charset || 'utf-8'}"
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
        ::CGI.rfc1123_date(@date)
      end
    end

    class Body
      attr_reader :type, :charset
      attr_accessor :date, :message

      def initialize(body, type='text/html', date=nil, charset='utf-8')
        @body = body
        @type = type
        @charset = charset
        @date = date
        @message = nil
        validate_body
      end

      # substitude invalid chars to GETA KIGO.
      def validate_body
        if @body && /\b(?:html|xml)\b/ =~ @type
          @body.scrub!
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
