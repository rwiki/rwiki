require 'test/unit'
require 'htree'

require 'rw-config'

require 'rwiki/rwiki'
require 'rwiki/db/mock'

class TestPreview < Test::Unit::TestCase

  def setup
    @db = RWiki::DB::Mock.new
    RWiki::BookConfig.default.db = @db
    RWiki::Book.section_list.clear
    @book = RWiki::Book.new
    @page = @book["top"]
  end

  def test_preview
    srcs = [
      "first\n",
      "second\n",
      "third\n",
    ]
    revs = []

    srcs.each do |src|
      @page.src = src
      revs << @page.revision
    end

    assert_equal(srcs.last, @page.src)

    srcs.each_with_index do |src, i|
      assert_equal(src, @page.src(revs[i]))
    end
  end

end
