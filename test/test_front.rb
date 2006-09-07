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

  def test_rename
    new_page = @book["new page"]
    src = "= #{@page.name}\n"
    @page.src = src
    req = RWiki::Request.new("submit", @page.name, src)
    env = {}
    block = Proc.new do |key|
      case key
      when "new_name"
        new_page.name
      else
        nil
      end
    end

    assert(new_page.empty?)
    result = @front.funcall(:rename, req.src, req, env.dup, &block)
    assert_equal(new_page.submit_html(env.dup, &block), result)
    assert(@page.empty?)
    assert_equal(src, new_page.src)

    @page.src = src
    assert(!new_page.empty?)
    result = @front.funcall(:rename, req.src, req, env.dup, &block)
    assert_equal(@front.funcall(:edit_view_with_message,
                                :destination_page_is_exist,
                                [new_page.name], req, env.dup, &block),
                 result)
    assert(!@page.empty?)

    new_page.src = "= #{new_page.name}\n"
    assert_not_equal(src, new_page.src)
    new_block = Proc.new do |key|
      case key
      when "rename_force"
        "true"
      else
        block.call(key)
      end
    end
    result = @front.funcall(:rename, req.src, req, env.dup, &new_block)
    assert_equal(new_page.submit_html(env.dup, &new_block), result)
    assert(@page.empty?)
    assert_equal(src, new_page.src)
  end
end
