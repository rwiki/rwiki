require 'db-test-util'

require 'rwiki/db/groonga'

class TestDBMock < Test::Unit::TestCase
  include DBTestUtil
  TEST_GROONGA_PATH = '/var/tmp/db_grng'

  def setup
    super
    setup_basic
  end

  def teardown
    super
    teardown_basic
  end

  def test_db_empty_name
    # ignore
  end

  def test_each_with_prefix
    @db = make_db
    name = "rw-01"
    @db['r000'] = 'test'
    @db.each {|it| assert_equal('r000', it)}

    @db['s000'] = 'test'
    assert_equal(%w(r000 s000),  @db.each.to_a)

    100.times do
      @db[name] = 'test'
      name = name.succ
    end
    assert_equal(
      %w(rw-01 rw-02 rw-03 rw-04 rw-05 rw-06 rw-07 rw-08 rw-09), 
      @db.each("rw-0").to_a)
  end

  private
  def version_management_available?
    false
  end

  def merge_available?
    false
  end

  def diff_available?
    false
  end
  
  def move_version_management_available?
    false
  end

  def annotate_available?
    false
  end

  def make_db
    RWiki::DB::Groonga.new(TEST_GROONGA_PATH)
  end

  def default_revision
    nil
  end
  
  def setup_basic
  end

  def teardown_basic
    FileUtils.rm_rf(TEST_GROONGA_PATH)
  end
end
