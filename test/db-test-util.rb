require "time"

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
    name1 = 'name1'
    name2 = 'name2'
    src1 = "= Sample1\n"
    src2 = "= Sample2\n"
    
    @db[name1] = src1
    assert_equal(src1, @db[name1])
    rev = @db.revision(name1)
    @db[name1, rev] = src2
    assert_equal(src2, @db[name1])
    assert(rev != @db.revision(name1))
    assert(src1, @db[name1, rev])

    assert_equal(nil, @db[name2])
    assert_equal(default_revision, @db.revision(name2))
    assert_equal(nil, @db.modified(name2))

    assert_raise(RWiki::RevisionError) do 
      @db[name1, rev] = "= Sample3\n"
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
    assert_equal(dates, @db.logs(name).collect do |log|
                   if log.date
                     Time.parse(log.date.iso8601) # remove usec
                   else
                     log.date
                   end
                 end)
    assert_equal(commit_logs, @db.logs(name).collect{|log| log.commit_log})
  end

  def test_not_versioned_logs
    return unless version_management_available?
    @db = make_db
    name = "not versioned"
    assert_equal([], @db.logs(name))
  end
  
  def test_diff
    return unless version_management_available?
    @db = make_db
    name = "top"
    before_src = "before\n"
    after_src = "after\n"
    commit_log = "diff"
    
    @db[name] = before_src
    before_rev = @db.revision(name)
    @db[name] = after_src
    after_rev = @db.revision(name)

    assert_match(/-#{before_src}\+#{after_src}\z/,
                 @db.diff(name, before_rev, after_rev))
  end

  def test_merge
    return unless merge_available?
    
    @db = make_db
    name = "top"
    base_src = "1\n\n2\n\n3\n"
    first_src = "1\n\n20\n\n3\n"
    second_src = "1\n\n2\n\n30\n"
    merged_src = "1\n\n20\n\n30\n"
    commit_log = "diff"

    @db[name] = base_src
    rev = @db.revision(name)
    
    @db[name, rev] = first_src
    @db[name, rev] = second_src

    assert_equal(merged_src, @db[name])
  end

end
