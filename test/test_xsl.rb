require 'test/unit'
require 'rss/1.0'

require 'erb'

require 'rw-config'

require 'rwiki/rwiki'
require 'rwiki/db/mock'
require 'rwiki/rss/writer'

class TestXSL < Test::Unit::TestCase
  include ERB::Util

  def setup
    @db = RWiki::DB::Mock.new
    RWiki::BookConfig.default.db = @db
    init_book
  end

  def test_core
    base_url = "http://example.com/"
    env = {"base_url" => base_url}

    xsl = REXML::Document.new(@book.front.xsl_view(env))

    assert_equal("http://www.w3.org/1999/XSL/Transform", xsl.root.namespace)
    assert_equal("stylesheet", xsl.root.local_name)
  end

  def test_css
    base_url = "http://example.com/"
    env = {"base_url" => base_url}
    xpath = "/xsl:stylesheet/xsl:template/head/link[@rel='stylesheet']"

    xsl = REXML::Document.new(@book.front.xsl_view(env))

    assert_nil(xsl.elements[xpath])
    
    RWiki.const_set(:RSS_CSS, "http://example.com/rss.css")
    init_book

    xsl = REXML::Document.new(@book.front.xsl_view(env))

    assert_equal(RWiki::RSS_CSS, xsl.elements[xpath].attributes["href"])
  end
  
  private
  def init_book
    @book = RWiki::Book.new
    top = @book[RWiki::TOP_NAME]
    top.src = "= top"
  end
  
end
