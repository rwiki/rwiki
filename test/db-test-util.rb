require 'test/unit'

module DBTestUtil
  def setup
    @db = nil
  end

  def teardown
    @db.close if @db
  end
  
  def test_db_core
    @db = make_db
    @db['top'] = "= Top\n"
    assert_equal("= Top\n", @db['top'])
    rev = @db.revision('top')
    @db['top', rev] = "= Top2\n"
    assert_equal("= Top2\n", @db['top'])
    assert(rev != @db.revision('top'))

    assert_equal(nil, @db['test'])
    assert_equal(default_revision, @db.revision('test'))
    assert_equal(nil, @db.modified('test'))

    assert_raise(RWiki::RevisionError) do 
      @db['top', rev] = "= Top3\n"
    end
  end
  
  def test_commit_log
    return unless version_management_available?
    @db = make_db
    name = "top"
    src = "= Top\n"
    commit_log = "log"
    params = {"commit_log" => commit_log}
    
    @db[name] = src * 2
    assert_equal(nil, @db.log(name))
    
    @db[name, nil, params] = src
    assert_equal(commit_log, @db.log(name))
  end
  
  def test_logs
    return unless version_management_available?
    @db = make_db
    name = "top"
    src1 = "= Top\n"
    src2 = "= Top2\n"
    commit_log1 = "log1"
    params1 = {"commit_log" => commit_log1}
    revs = []
    dates = []
    commit_logs = []
    
    @db[name, nil, params1] = src1
    rev = @db.revision(name)
    revs.unshift(rev)
    dates.unshift(@db.modified(name))
    commit_logs.unshift(commit_log1)
    @db[name, rev] = src2
    revs.unshift(@db.revision(name))
    dates.unshift(@db.modified(name))
    commit_logs.unshift(nil)

    assert_equal(revs, @db.logs(name).collect{|log| log.revision})
    assert_equal(dates, @db.logs(name).collect{|log| log.date})
    assert_equal(commit_logs, @db.logs(name).collect{|log| log.commit_log})
  end
end
