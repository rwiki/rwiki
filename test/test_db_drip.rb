require 'db-test-util'

require 'rwiki/db/drip'
require 'drip'

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
    RWiki::DB::Drip.new(@drip)
  end

  def default_revision
    nil
  end
  
  def setup_basic
    @drip = Drip.new(nil)
  end

  def teardown_basic
    @drip = nil
  end
end
