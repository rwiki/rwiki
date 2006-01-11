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
    assert_not_equal(rev, @db.revision(name1))
    assert(src1, @db[name1, rev])

    assert_equal(nil, @db[name2])
    assert_equal(default_revision, @db.revision(name2))
    assert_equal(nil, @db.modified(name2))

    assert_raise(RWiki::RevisionError) do
      @db[name1, rev] = "= Sample3\n"
    end

    assert_equal(src2, @db[name1])
    @db[name1] = ""
    assert_nil(@db[name1])
  end

  def test_commit_log
    return unless version_management_available?
    @db = make_db
    name1 = "page1"
    name2 = "page2"
    src1 = "= Page1\n"
    src2 = "= Page2\n"
    commit_log1 = "log1"
    commit_log2 = "log2"

    params = {"commit_log" => commit_log1}
    @db[name1] = src1
    assert_equal(nil, @db.log(name1))

    @db[name1, nil, params] = src1 * 2
    assert_equal(commit_log1, @db.log(name1))

    params = {"commit_log" => commit_log2}
    @db[name2] = src2
    assert_equal(commit_log1, @db.log(name1))
    assert_equal(nil, @db.log(name2))

    @db[name2, nil, params] = src2 * 2
    assert_equal(commit_log1, @db.log(name1))
    assert_equal(commit_log2, @db.log(name2))
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
    log_dates = @db.logs(name).collect {|log| log.date}
    dates.each_with_index do |date, i|
      assert_operator(date - 2, :<=, log_dates[i])
      assert_operator(date + 2, :>=, log_dates[i])
    end
    assert_equal(commit_logs, @db.logs(name).collect{|log| log.commit_log})
  end

  def test_not_versioned_logs
    return unless version_management_available?
    @db = make_db
    name = "not versioned"
    assert_equal([], @db.logs(name))
  end

  def test_diff
    return unless diff_available?
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

  def test_diff_from_epoch
    return unless diff_available?
    @db = make_db
    name = "top"
    src1 = "a\nb\nc\n"
    src2 = "d\ne\nf\n"
    commit_log = "diff"

    @db[name] = src1
    rev1 = @db.revision(name)
    @db[name] = src2
    rev2 = @db.revision(name)

    re1 = Regexp.new(src1.collect {|line| "^\\+#{line}"}.join("") + "\\z")
    assert_match(re1, @db.diff(name, nil, rev1))
    re2 = Regexp.new(src2.collect {|line| "^\\+#{line}"}.join("") + "\\z")
    assert_match(re2, @db.diff(name, nil, rev2))
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

  def test_commit_log_is_pathname
    return unless version_management_available?
    @db = make_db
    name = "pagename"
    src = "= Page\n"
    commit_log = Dir.entries(".").sort[-1]

    params = {"commit_log" => commit_log}
    @db[name, nil, params] = src
    assert_equal(commit_log, @db.log(name))
  end

  def test_move
    @db = make_db
    old_name = "old-page"
    new_name = "new-page"
    src = "= Page\n"

    @db[old_name] = src
    assert_equal(src, @db[old_name])
    assert_nil(@db[new_name])

    @db.move(old_name, new_name)
    assert_nil(@db[old_name])
    assert_equal(src, @db[new_name])
  end

  def test_move_conflict
    @db = make_db
    old_name = "old-page"
    new_name = "new-page"
    src = "= Page\n"
    src2 = "= Page2\n"

    @db[old_name] = src
    @db[new_name] = src2
    assert_equal(src, @db[old_name])
    assert_equal(src2, @db[new_name])

    @db.move(old_name, new_name)
    assert_nil(@db[old_name])
    assert_equal(src, @db[new_name])
  end

  def test_move_with_source
    @db = make_db
    old_name = "old-page"
    new_name = "new-page"
    src = "= Page\n"
    src2 = "= Page2\n"

    @db[old_name] = src
    assert_equal(src, @db[old_name])

    @db.move(old_name, new_name, src2)
    assert_nil(@db[old_name])
    assert_equal(src2, @db[new_name])
  end

  def test_move_diff
    return unless move_version_management_available?
    @db = make_db
    old_name = "old-page"
    new_name = "new-page"
    before_src = "before\n"
    after_src = "after\n"

    @db[old_name] = before_src
    before_rev = @db.revision(old_name)
    assert_equal(before_src, @db[old_name])
    
    @db.move(old_name, new_name, after_src)
    after_rev = @db.revision(new_name)
    assert_nil(@db[old_name])
    assert_equal(after_src, @db[new_name])

    assert_match(/-#{before_src}\+#{after_src}\z/,
                 @db.diff(new_name, before_rev, after_rev))
  end

  def test_move_diff_from_epoch
    return unless move_version_management_available?
    @db = make_db
    old_name = "old-page"
    new_name = "new-page"
    src1 = "a\nb\nc\n"
    src2 = "d\ne\nf\n"
    commit_log = "diff"
    
    @db[old_name] = src1
    rev1 = @db.revision(old_name)
    assert_equal(src1, @db[old_name])
    
    @db.move(old_name, new_name, src2)
    after_rev = @db.revision(new_name)
    assert_nil(@db[old_name])
    assert_equal(src2, @db[new_name])

    re1 = Regexp.new(src1.collect {|line| "^\\+#{line}"}.join("") + "\\z")
    # assert_match(re1, @db.diff(old_name, nil, rev1))
    assert_match(re1, @db.diff(new_name, nil, rev1))
    re2 = Regexp.new(src2.collect {|line| "^\\+#{line}"}.join("") + "\\z")
    assert_match(re2, @db.diff(new_name, nil, rev2))
  end
end
