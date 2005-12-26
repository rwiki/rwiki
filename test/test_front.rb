require 'test/unit'
require 'htree'

require 'rw-config'

require 'rwiki/rwiki'
require 'rwiki/db/mock'
require 'rwiki/front'

class TestFront < Test::Unit::TestCase

  def setup
    @db = RWiki::DB::Mock.new
    RWiki::BookConfig.default.db = @db
    RWiki::Book.section_list.clear
    @book = RWiki::Book.new
    @page = @book["page"]
    @front = @book.front
  end

  def test_edit_view
    @page.src = "= #{@page.name}\n"
    rev = @page.revision
    @page.src = "= #{@page.name}\ncontent\n"

    assert_equal(@page.edit_html, @front.edit_view(@page.name))
    assert_equal(@page.edit_html(rev), @front.edit_view(@page.name, rev))
  end

  def test_charset
    assert_equal($KCODE, @front.KCODE)
  end

end
