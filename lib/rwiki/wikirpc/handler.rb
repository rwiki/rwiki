# -*- indent-tabs-mode: nil -*-
# lib/rwiki/xmlrpc/handler.rb -- WikiRPC handlers
#
# Copyright (c) 2004-2005 Kazuhiro NISHIYAMA
#
# You can redistribute it and/or modify it under the same terms as Ruby.

require 'drb/drb'
require 'rwiki/rw-lib'

module RWiki
  module WikiRPC
    module Handler
      VERSION = [
        'rwiki/xmlrpc/handler',
        '$Id$'
      ]
      INTERPRETER_VERSION = [
        'ruby (WikiRPC interface)',
        "#{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
      ]

      module_function
      def get_env
        env = Hash.new
        env['rw-agent-info'] = [VERSION, INTERPRETER_VERSION]
        env
      end

      def sandbox(rwiki)
        binding
      end

      def init_wikirpc_handlers(server, rwiki)
        [
         # array getRecentChanges( Date timestamp )
         ['getRecentChanges', %w'array dateTime.iso8601 timestamp'],
         # int getRPCVersionSupported()
         ['getRPCVersionSupported', %w'int'],
         # utf8 getPage( utf8 pagename )
         ['getPage', %w'string string pagename'],
         # utf8 getPageVersion( utf8 pagename, int version )
         ['getPageVersion', %w'string string pagename int version'],
         # utf8 getPageHTML( utf8 pagename )
         ['getPageHTML', %w'string string pagename', nil, true],
         # utf8 getPageHTMLVersion( utf8 pagename, int version )
         ['getPageHTMLVersion', %w'string string pagename int version', nil, true],
         # array getAllPages()
         ['getAllPages', %w'array'],
         # struct getPageInfo( utf8 pagename )
         ['getPageInfo', %w'struct string pagename'],
         # struct getPageInfoVersion( utf8 pagename, int version )
         ['getPageInfoVersion', %w'struct string pagename int version'],
         # array listLinks( utf8 pagename )
         ['listLinks', %w'array string pagename'],

         # API ver2
         # array getBackLinks( utf8 page )
         ['getBackLinks', %w'array string pagename'],
         # putPage( utf8 page, utf8 content, struct attributes )
         ['putPage', %w'boolean string pagename string content struct attributes'],
         # array listAttachments( utf8 page )
         ['listAttachments', %w'array string pagename'],
         # base64 getAttachment( utf8 attachmentName )
         ['getAttachment', %w'base64 string attachmentName'],
         # putAttachment( utf8 attachmentName, base64 content )
         ['putAttachment', %w'boolean string attachmentName base64 content'],
        ].each do |method_name, method_signature, method_help, need_env|
          retval_type, *args_info = method_signature
          i = 0
          args_type, xmlrpc_args = args_info.partition{(i+=1)%2==1}
          if need_env
            drb_args = xmlrpc_args + ['::RWiki::WikiRPC::Handler.get_env']
          else
            drb_args = xmlrpc_args
          end
          code = <<-"CODE"
            proc do |#{xmlrpc_args.join(',')}|
              rwiki.wikirpc_front.#{method_name}(#{drb_args.join(',')})
            end
          CODE
          block = eval(code, sandbox(rwiki), "(wiki.#{method_name})", 1)
          server.add_handler("wiki.#{method_name}",
                             "#{retval_type} #{args_type.join(' ')}",
                             method_help, &block)
        end
      end

      def init_handlers(server, rwiki)
        init_wikirpc_handlers(server, rwiki)
        server.add_introspection
        server.add_multicall
      end
    end
  end
end
