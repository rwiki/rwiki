require 'test/unit'
require 'rwiki/db/mock'

class TestDBMock < Test::Unit::TestCase
  def setup
  end

  def teardown
  end

  def test_db_mock
    db = RWiki::DB::Mock.new
    db['top'] = "= Top\n"
    assert_equal("= Top\n", db['top'])
    rev = db.revision('top')
    db['top', rev] = "= Top2\n"
    assert_equal("= Top2\n", db['top'])
    assert(rev != db.revision('top'))

    assert_equal(nil, db['test'])
    assert_equal(nil, db.revision('test'))
    assert_equal(nil, db.modified('test'))

    assert_raise(RWiki::RevisionError) do 
      db['top', rev] = "= Top3\n"
    end
  end
end
