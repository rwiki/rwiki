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

  def test_response_sync_body_date
    content = ''
    time = Time.now
    header = RWiki::Response::Header.new
    body = RWiki::Response::Body.new(content)
    response = RWiki::Response.new(header, body)
    response.body.date = time
    assert_match(/^last-modified: #{Regexp.quote(time.httpdate)}\r\n/i, response.dump)
    assert_equal(response.body.date, response.header.date)
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

  EUC_kana_a = "\244\242"
  SJIS_kana_a = "\202\240"
  UTF8_kana_a = "\343\201\202"

  def assert_kcode_utf8(utf8_str, kcode_str)
    assert_equal(utf8_str, RWiki::KCode.to_utf8(kcode_str))
    assert_equal(kcode_str, RWiki::KCode.from_utf8(utf8_str))
  end
  def assert_kcode_utf8_kana_a(kcode_str)
    assert_kcode_utf8(UTF8_kana_a, kcode_str)
  end

  def test_kcode_utf8_euc
    $KCODE = 'e'
    assert_kcode_utf8_kana_a(EUC_kana_a)
  end
  def test_kcode_utf8_sjis
    $KCODE = 's'
    assert_kcode_utf8_kana_a(SJIS_kana_a)
  end
  def test_kcode_utf8_utf8
    $KCODE = 'u'
    assert_kcode_utf8_kana_a(UTF8_kana_a)
  end
end
