require 'logger'
require 'soap/rpc/driver'

require 'rwiki/soap/common'

module RWiki
  module SOAP
    class Driver < ::SOAP::RPC::Driver
  
      APP_NAME = 'RWikiSOAPDriver'

      def initialize(end_point, soap_action=nil)
        super(end_point, RWiki::SOAP::NS, soap_action)

        add_method('allow_get_page')
        add_method('page', 'name')

        add_method('drb_host_and_port')

        add_method('include', 'name')
        add_method('find', 'str')
        add_method('src', 'name')
        add_method('body', 'name')
        add_method('modified', 'name')
        add_method('revision', 'name')
        add_method('rd2content', 'src')
        add_method('recent_changes')
        add_method('copy', 'name', 'src')
        add_method('append', 'name', 'src')
        add_method('submit', 'name', 'src', 'rev', 'log')
      end

      def log_dir=(new_value)
        if new_value.nil?
          self.wiredump_file_base = nil
        else
          self.wiredump_file_base = File.join(new_value, APP_NAME)
        end
      end

    end
  end
end
