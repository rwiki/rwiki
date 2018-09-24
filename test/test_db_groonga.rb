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
