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

  def setup
    @orig_kcode = $KCODE
  end

  def teardown
    $KCODE = @orig_kcode
  end

  def test_body_nil
    body = RWiki::Response::Body.new(nil)
    assert_equal(nil, body.dump)
    assert_equal(RWiki::KCode.charset, body.charset)
    assert_equal(nil, body.date)
    assert_equal(nil, body.message)
    assert_equal(nil, body.size)
  end

  def test_body_empty
    body = RWiki::Response::Body.new('')
    assert_equal('', body.dump)
    assert_equal(RWiki::KCode.charset, body.charset)
    assert_equal(nil, body.date)
    assert_equal(nil, body.message)
    assert_equal(0, body.size)
  end

  def test_body_geta_charref
    body = RWiki::Response::Body.new('&#x0;&#x20;')
    assert_equal('&#x3013;&#x20;', body.dump)
    assert_equal(RWiki::KCode.charset, body.charset)
    assert_equal(nil, body.date)
    assert_equal(nil, body.message)
    assert_equal(14, body.size)
  end

  def test_body_geta_char
    body = RWiki::Response::Body.new("\x1\x1a test\r\n")
    assert_equal("&#x3013;&#x3013; test\r\n", body.dump)
    assert_equal(RWiki::KCode.charset, body.charset)
    assert_equal(nil, body.date)
    assert_equal(nil, body.message)
    assert_equal(23, body.size)
  end
  def test_body_geta_char_utf8
    $KCODE = 'u'
    test_body_geta_char
  end
  def test_body_geta_char_euc
    $KCODE = 'e'
    test_body_geta_char
  end
  def test_body_geta_char_sjis
    $KCODE = 's'
    test_body_geta_char
  end
  def test_body_geta_char_none
    $KCODE = 'n'
    test_body_geta_char
  end
end
