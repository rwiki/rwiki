require 'rw-config'
require 'rwiki/rw-lib'

class TestRWLib < Test::Unit::TestCase

  def test_base
    env = {}
    assert_equal("rw-cgi.rb", RWiki::Request.base(env))

    name = "index.cgi"
    env["SCRIPT_NAME"] = name
    assert_equal(name, RWiki::Request.base(env))

    base = "/~rwiki/"
    param = "?cmd=view;name=top"
    env["REQUEST_URI"] = "#{base}#{param}"
    assert_equal(base, RWiki::Request.base(env))

    host = "localhost"
    port = "10203"
    env["REQUEST_URI"] = "http://#{host}:#{port}#{base}#{param}"
    assert_equal(base, RWiki::Request.base(env))
  end
end
