require 'db-test-util'

require 'rwiki/db/file'

class TestDBMock < Test::Unit::TestCase
  include DBTestUtil

  def setup
    super
    setup_basic
  end

  def teardown
    super
    teardown_basic
  end

  private
  def version_management_available?
    false
  end

  def merge_available?
    false
  end

  def move_version_management_available?
    false
  end
  
  def make_db
    RWiki::DB::File.new(@path)
  end

  def default_revision
    MD5.new(nil).hexdigest
  end
  
  def setup_basic
    @path = File.join("test", ".rd")
    FileUtils.mkdir_p(@path)
  end

  def teardown_basic
    FileUtils.rm_rf(@path)
  end
end
