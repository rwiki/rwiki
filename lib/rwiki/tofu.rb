require 'rwiki/rw-lib'

module RWiki
  class TofuService
    VERSION = ['rwiki/tofu', '1.0']

    def initialize(rwiki)
      @rwiki = rwiki
    end

    def do_GET(context)
      env = get_env(context)
      params = context.req_params

      rw_req = RWiki::Request.parse(params)

      context.res_header('Cache-Control', 'no-cache')

      if src_with_IMS?(context, rw_req)
	not_modified(context)
	return
      end

      body = @rwiki.process_request(rw_req, env) { |k| params[k] }
      context.res_body(body)

      content_type = 'text/html; charser=' + RWiki::KCode.charset
      context.res_header('content-type', content_type)

    rescue DRb::DRbConnError
      on_rwiki_server_down(context)
    rescue RWiki::InvalidRequest
      on_request_error(context, env)
    rescue RWiki::RevisionError
      on_revision_error(context, env, rw_req)
    rescue
      on_unknown_error(context, env, $!, $@)
    end

    def src_with_IMS?(context, rw_req)
      return false unless rw_req.cmd == 'src'
      ims_str = context.req_meta_vars['HTTP_IF_MODIFIED_SINCE']
      return false unless ims_str
      ims = Time.parse(ims_str)
      @rwiki.page(cmd.name).modified <= ims
    end

    private
    def get_env(context)
      absolute_path = context.req_absolute_path
      script_name = context.req_script_name.to_s + '/'
      base_url = absolute_path + script_name
      
      env = Hash.new
      env['base'] = script_name
      env['base_url'] = base_url
      env['rw-agent-info'] = [VERSION]
      
      env
    end

    def on_request_error(context, env)
      redirect_to_top(context, env)
    end

    def on_revision_error(context, env, rw_req)
      message =<<__EOM__
Source revision mismatch.

Page '#{ rw_req.name }' has changed since editing started.
Back to the edit page and press 'RELOAD' to refresh the page,
then retry to merge/add your changes to its latest source.

Submitted source:
#{ rw_req.src }
__EOM__
      error_response(context, env, rw_req.name, message)
    end

    def on_unknown_error(context, env, err, info)
      message = "#{ err }\n\n" << info.join( "\n" )
      error_response(context, env, 'error', message)
    end

    def error_response(context, env, name, message)
      name = 'error' unless name
      body = @rwiki.error_view(name, env) do |key|
	case key
	when 'message'
	  message
	else
	  ''
	end
      end
      context.res_header('status', '500')
      content_type = 'text/html; charser=' + RWiki::KCode.charset
      context.res_header('content-type', content_type)
      context.res_body(body)
    end

    public
    def on_rwiki_server_down(context)
      context.res_header('status', '503')
      context.res_header('content-type', 'text/plain')
      context.res_body('RWiki server seems to be down...')
    end

    def redirect_to_top(context, env=nil)
      env = get_env(context) unless env
      redirect_to = @rwiki.default_url(env)
      context.res_header('status', '302')
      context.res_header('location', redirect_to)
      context.res_body('')
    end

    def not_modified(context)
      context.res_header('status', '304')
      context.res_body('')
    end
  end
end
