require 'test/unit'
require 'rss/1.0'

require 'erb'

require 'rw-config'

require 'rwiki/rwiki'
require 'rwiki/db/mock'
require 'rwiki/rss-writer'

class TestRSS < Test::Unit::TestCase
  include ERB::Util

  def setup
    @db = RWiki::DB::Mock.new
    RWiki::BookConfig.default.db = @db
    init_book
  end

  def test_core
    base_url = "http://example.com/"
    env = {"base_url" => base_url}
    assert_nothing_raised do
      RSS::Parser.parse(@book.front.rss_view(env))
    end
    
    top = @book[RWiki::TOP_NAME]
    top.src = ""
    assert_raises(RSS::MissingTagError) do
      RSS::Parser.parse(@book.front.rss_view(env))
    end
    rss = RSS::Parser.parse(@book.front.rss_view(env), false)
    assert_equal(0, rss.items.size)
  end
  
  def test_image
    base_url = "http://example.com/"
    top_query = RWiki::Request.new('view', RWiki::TOP_NAME).query
    env = {"base_url" => base_url}
    rss = RSS::Parser.parse(@book.front.rss_view(env))

    assert_nil(rss.image)

    RWiki.const_set(:IMAGE, "http://example.com/XXX.png")
    init_book
    
    rss = RSS::Parser.parse(@book.front.rss_view(env))
    assert_equal(RWiki::IMAGE, rss.channel.image.resource)
    assert_equal(RWiki::IMAGE, rss.image.about)
    assert_equal(RWiki::TITLE, rss.image.title)
    assert_equal(RWiki::IMAGE, rss.image.url)
    assert_equal("#{base_url}?#{top_query}", rss.image.link)
  end

  def test_title
    page = @book.recent_changes.first
    def page.title
      name + "-title"
    end
    
    base_url = "http://example.com/"
    top_query = RWiki::Request.new('view', RWiki::TOP_NAME).query
    env = {"base_url" => base_url}
    rss = RSS::Parser.parse(@book.front.rss_view(env))

    assert_equal(page.title, rss.items.first.title)
  end

  def test_description
    base_url = "http://example.com/"
    top_query = RWiki::Request.new('view', RWiki::TOP_NAME).query
    env = {"base_url" => base_url}
    rss = RSS::Parser.parse(@book.front.rss_view(env))

    assert_nil(rss.items.first.description)
    

    commit_log = "log"
    params = {"commit_log" => commit_log}
    page = @book.recent_changes.first
    page.set_src("dummy source", nil) {|key| params[key]}
    
    base_url = "http://example.com/"
    top_query = RWiki::Request.new('view', RWiki::TOP_NAME).query
    env = {"base_url" => base_url}
    rss = RSS::Parser.parse(@book.front.rss_view(env))
 
    assert_equal(commit_log, rss.items.first.description)
  end
  
  private
  def init_book
    @book = RWiki::Book.new
    top = @book[RWiki::TOP_NAME]
    top.src = "= top"
  end
  
end
