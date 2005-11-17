#!/usr/bin/ruby -Ku

$LOAD_PATH.unshift "/var/lib/ruby-man/lib"

require 'drb/drb'

require 'rwiki/cgi'
require 'rwiki/service'

rwiki_uri = "druby://localhost:7429"
rwiki_log_file = "/var/lib/ruby-man/log/ruby-man.log"

DRb.start_service("druby://localhost:0")
log_level = Logger::Severity::ERROR
rwiki = DRbObject.new_with_uri(rwiki_uri)
service = RWiki::Service.new(rwiki, log_level)
def service.prologue
  if /\bname=cmd\.php\b/ =~ @req.query_string
    error("Invalid page name from #{remote_host}: query_string=#{@req.query_string.inspect}")
    raise WEBrick::HTTPStatus::Forbidden, 'Invalid page name'
  end
end
service.set_log(rwiki_log_file, 'weekly')
cgi = RWiki::CGI.new({}, service)
cgi.start
