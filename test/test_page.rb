require 'test/unit'

require 'rw-config'

require 'rwiki/rwiki'
require 'rwiki/db/mock'

class TestPage < Test::Unit::TestCase

  def setup
    @db = RWiki::DB::Mock.new
    RWiki::BookConfig.default.db = @db
    RWiki::Book.section_list.clear
    @book = RWiki::Book.new
    @top_name = RWiki::TOP_NAME
    @top = @book[@top_name]
    @page = @book["page"]
  end

  def test_title
    name = "page-name"
    page = @book[name]
    assert_equal(name, page.name)
    assert_equal(name, page.title)
    def page.title
      "page-title"
    end
    assert_equal("page-title", page.title)
    assert_equal(name, page.name)
  end
end
