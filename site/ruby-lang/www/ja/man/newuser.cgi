#!/usr/bin/ruby

HTPASSWD_FILE = "/var/lib/ruby-man/auth/ja-man.htpasswd"
REALM = nil

require 'cgi'
cgi = CGI.new('html4Tr')
params = cgi.params
user, = params['u']
pass, = params['p']
confirm, = params['c']

u = user.to_s
p1 = pass.to_s
p2 = confirm.to_s

begin
  if cgi.request_method != 'POST'
    message = ''
  elsif /\A[A-Za-z0-9_\-]+\z/n !~ u
    message = 'invalid user'
  elsif /\A[ -~]+\z/n !~ p1 || p1 != p2
    message = 'invalid password or confirm failed'
  else
    require 'webrick/httpauth/htpasswd'
    htpasswd = WEBrick::HTTPAuth::Htpasswd.new(HTPASSWD_FILE)
    if htpasswd.get_passwd(REALM, u, nil)
      message = 'user exists'
    else 
      require 'fileutils'
      FileUtils.cp(HTPASSWD_FILE, "#{HTPASSWD_FILE}.#{Time.now.to_i.to_s}", :preserve => true)
      htpasswd.set_passwd(REALM, u, p1)
      htpasswd.flush
      FileUtils.chmod(0660, HTPASSWD_FILE)
      message = 'create new user'
    end
  end
rescue
  message = $!.to_s
end
cgi.out do
  cgi.html do
    cgi.p { message } +
    cgi.form do
      'user:' + cgi.br +
      cgi.text_field('u', u) + cgi.br +
      'password:' + cgi.br +
      cgi.password_field('p', p1) + cgi.br +
      'password confirmation:' + cgi.br +
      cgi.password_field('c', p2) + cgi.br +
      cgi.submit
    end
  end
end
