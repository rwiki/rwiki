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

  def test_logs
    db = RWiki::DB::Mock.new
    name = "top"
    src1 = "= Top\n"
    src2 = "= Top2\n"
    revs = []
    dates = []
    
    db[name] = src1
    rev = db.revision(name)
    revs << rev
    dates << db.modified(name)
    db[name, rev] = src2
    revs << db.revision(name)
    dates << db.modified(name)

    assert_equal(revs, db.logs(name).collect{|log| log.revision})
    assert_equal(dates, db.logs(name).collect{|log| log.date})
  end
end
