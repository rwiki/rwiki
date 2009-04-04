# Deny spam access by Realtime Blacking List

require 'socket'

module RWiki
  module RBL
    class Error < StandardError
      attr_reader :label, :uri, :remote_address
      def initialize(label, uri, remote_address)
        @label = label
        @uri = uri
        @remote_address = remote_address
        super("Find #{@remote_address} in #{@label}(#{@uri})")
      end
    end

    LISTS = [
      ["ALL(RBL.JP)", "all.rbl.jp"],
      ["URL(RBL.JP)", "url.rbl.jp"],
      ["Dynamic DNS(RBL.JP)", "dyndns.rbl.jp"],
      ["Spam Champuru DNSBL", "dnsbl.spam-champuru.livedoor.com"],
    ]

    def reject(error, req, env, &block)
      format = _("Rejected an access from %{address} because " \
                 "there is the IP address in RBL %{label}(%{URI}).")
      message = format % {:address => error.remote_address,
                          :label => error.label,
                          :URI => error.uri}
      error_view(req.name, env) do |key|
        if key == "message"
          message
        else
          ''
        end
      end
      header = Response::Header.new(404)
      response = make_response(result, header)
      response.body.message = message
      response
    end

    def do_post_submit(req, env={}, &block)
      check_rbl(env['remote-address'])
      super
    rescue Error
      reject($!, req, env, &block)
    end

    private
    def check_rbl(remote_address)
      return if remote_address.nil?
      reversed_remote_address = remote_address.split(/\./).reverse.join(".")
      LISTS.each do |label, uri|
        begin
          result = Socket.gethostbyname("#{reversed_remote_address}.#{uri}.")
          result_address = result.last.unpack("C4").join(".")
          if /^127\./ =~ result_address
            raise Error.new(label, uri, remote_address)
          end
        rescue SocketError
        end
      end
    end
  end
end
