require 'db-test-util'

require 'rwiki/db/cvs'

class TestDBCVS < Test::Unit::TestCase
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
    true
  end

  def merge_available?
    true
  end

  def diff_available?
    true
  end

  def move_version_management_available?
    false
  end
  
  def make_db
    RWiki::DB::CVS.new(@wc_path)
  end

  def default_revision
    "HEAD"
  end

  def setup_basic
    @repos_path = File.join("test", "repos")
    @repos_full_path = File.join(Dir.pwd, @repos_path)
    @wc_path = File.join("test", "wc")
    @mod_name = "rd"
    setup_repository(@repos_path)
    cvs("co", "-d", @wc_path, @mod_name)
  end

  def teardown_basic
    teardown_repository(@repos_path)
    FileUtils.rm_rf(@wc_path)
  end

  def setup_repository(path, config={}, fs_config={})
    FileUtils.mkdir_p(File.dirname(path))
    cvs("init")
    FileUtils.mkdir(@wc_path)
    Dir.chdir(@wc_path) do
      cvs("import", "-m", "import", @mod_name, "rwiki", "test")
    end
    FileUtils.rm_r(@wc_path)
  end

  def teardown_repository(path)
    FileUtils.rm_rf(@repos_path)
  end

  def cvs(*args)
    `cvs -d #{@repos_full_path} #{args.join(' ')}`
  end
end
