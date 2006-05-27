require 'db-test-util'

require 'rwiki/db/svn'

class TestDBSvn < Test::Unit::TestCase
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
    true
  end

  def annotate_available?
    true
  end

  def make_db
    RWiki::DB::Svn.new(@wc_path)
  end

  def default_revision
    nil
  end
  
  def setup_basic
    @repos_path = File.join("test", "repos")
    @repos_uri = "file://#{File.expand_path(@repos_path)}"
    @wc_base_dir = File.join("test", "wc-tmp")
    @wc_path = File.join(@wc_base_dir, "wc")
    setup_repository(@repos_path)
    ctx = Svn::Client::Context.new
    ctx.add_username_prompt_provider(0) do |cred, realm, may_save|
      cred.username = "dummy"
      cred.may_save = false
    end
    FileUtils.rm_rf(@wc_path)
    ctx.checkout(@repos_uri, @wc_path)
  end

  def teardown_basic
    teardown_repository(@repos_path)
    FileUtils.rm_rf(@wc_base_dir)
  end

  def setup_repository(path, config={}, fs_config={})
    FileUtils.mkdir_p(File.dirname(path))
    FileUtils.rm_rf(path)
    Svn::Repos.create(path, config, fs_config)
  end

  def teardown_repository(path)
    Svn::Repos.delete(path)
  end
end
