require 'test/unit'
require 'xmlrpc/client'

class TestRWikiRPC < Test::Unit::TestCase
  def setup
    @client = XMLRPC::Client.new("localhost", "/", 8080)
    @proxy = @client.proxy("wiki")
  end

  def test_getRecentChanges
    assert_equal([], @proxy.getRecentChanges(Time.now.utc))
    actual = @proxy.getRecentChanges(Time.now.utc-24*60*60)
    assert_instance_of(Array, actual)
  end

  def test_getRPCVersionSupported
    assert_equal(2, @proxy.getRPCVersionSupported)
  end

  def test_getPage
    actual = @proxy.getPage("top")
    assert_instance_of(String, actual)
    e = assert_raise(XMLRPC::FaultException) {
      @proxy.getPage("no such page")
    }
    assert_equal(1, e.faultCode)
    assert_equal("No such page was found.", e.faultString)
  end

  def test_getPageHTML
    actual = @proxy.getPageHTML("top")
    assert_instance_of(String, actual)
    assert_match(/<html/, actual)

    e = assert_raise(XMLRPC::FaultException) {
      @proxy.getPageHTML("no such page")
    }
    assert_equal(1, e.faultCode)
    assert_equal("No such page was found.", e.faultString)
  end

  def test_getAllPages
    actual = @proxy.getAllPages
    assert_instance_of(Array, actual)
    actual.each do |str|
      assert_instance_of(String, str)
    end
  end

  def test_getPageInfo
    actual = @proxy.getPageInfo("top")
    assert_instance_of(Hash, actual)
    assert_equal("top", actual['name'])
    assert_instance_of(XMLRPC::DateTime, actual['lastModified'])
    assert_instance_of(NilClass, actual['author']) # should be String
    assert_kind_of(Integer, actual['version'])

    e = assert_raise(XMLRPC::FaultException) {
      actual = @proxy.getPageInfo("no such page")
    }
    assert_equal(1, e.faultCode)
    assert_equal("No such page was found.", e.faultString)
  end

  def test_listLinks
    actual = @proxy.listLinks("top")
    assert_instance_of(Array, actual)
    actual.each do |h|
      assert_instance_of(String, h['page'])
      assert_equal('local', h['type'])
      assert_instance_of(NilClass, h['href']) # should be String
    end

    e = assert_raise(XMLRPC::FaultException) {
      actual = @proxy.listLinks("no such page")
    }
    assert_equal(1, e.faultCode)
    assert_equal("No such page was found.", e.faultString)
  end

  def test_getBackLinks
    actual = @proxy.getBackLinks("RWiki")
    assert_instance_of(Array, actual)
    actual.each do |str|
      assert_instance_of(String, str)
    end

    e = assert_raise(XMLRPC::FaultException) {
      actual = @proxy.listLinks("no such page")
    }
    assert_equal(1, e.faultCode)
    assert_equal("No such page was found.", e.faultString)
  end
end
