#!/usr/bin/env ruby
# Fetch from RAA download URL
# copyright (c) 2003- ZnZ <zn@mbf.nifty.com>
# You can redistribute it and/or modify it under the same term as Ruby.

begin
  require 'time'
  require 'uri'
rescue LoadError
  puts "need ruby 1.6.8 or later"
  raise
end
require 'cgi'
require 'ftools'
require 'net/ftp'
require 'net/http'
require 'rbconfig'

Net::HTTP.version_1_2

class Fetcher
  def initialize(header = {}, proxy = ENV['http_proxy'])
    @header = header
    if proxy
      if proxy.is_a? URI
        @proxy = proxy
      else
        @proxy = URI.parse(proxy)
      end
      @http = Net::HTTP::Proxy(@proxy.host, @proxy.port)
      if @proxy.user and @proxy.password
        @header['Proxy-Authorization'] = basic_auth_string(@proxy)
      end
    else
      @proxy = false
      @http = Net::HTTP
    end
  end

  def basic_auth_string(uri)
    'Basic ' + ["#{uri.user}:#{uri.password}"].pack('m').strip
  end
  private :basic_auth_string

  def save_file(filename, body, mtime)
    dir = File.dirname(filename)
    unless File.exist?(dir)
      Dir.mkdir(dir)
    end
    File.open(filename, 'wb') do |f|
      f.write body
    end
    if mtime
      File.utime(Time.now, mtime, filename)
    end
  end
  private :save_file

  def http_get(uri, localfile)
    uri = URI.parse(uri) unless uri.is_a? URI
    response = nil
    header = @header.dup
    if uri.user
      header['Authorization'] = basic_auth_string(uri)
    end
    @http.start(uri.host, uri.port) do |http|
      response, = http.get(uri.request_uri, header)
    end
    mtime = nil
    begin
      mtime = Time.parse(response['last-modified'].to_s)
    rescue ArgumentError
      # ignore mtime parse error
    end
    save_file(localfile, response.body, mtime)
    response.body
  end

  def ftp_get(uri, localfile)
    return http_get(uri, localfile) if @proxy
    uri = URI.parse(uri) unless uri.is_a? URI
    ftp = Net::FTP.new
    ftp.connect(uri.host, uri.port)
    ftp.login((uri.user || 'anonymous'), uri.password)
    ftp.getbinaryfile(uri.path, localfile)
    ftp.close
    true
  end

  def get(uri, localfile)
    uri = URI.parse(uri) unless uri.is_a? URI
    case uri.scheme
    when 'http'
      http_get(uri, localfile)
    when 'ftp'
      ftp_get(uri, localfile)
    else
      raise "not supported scheme: `#{uri}'"
    end
  end
end

class RAA_Fetcher < Fetcher
  RUBY_EXE = File.join(Config::CONFIG['bindir'],
                       Config::CONFIG['ruby_install_name'])
  class Exists < StandardError; end

  def initialize(cache_dir = File.join(Dir.pwd, 'cache'),
                 header = {}, proxy = ENV['http_proxy'])
    super(header, proxy)
    self.cache_dir = cache_dir
    @bindir = @rbdir = @sodir = nil
  end

  def cache_dir=(dir)
    @cache_dir = dir
    unless File.exist?(@cache_dir)
      Dir.mkdir(@cache_dir)
    end
  end

  attr_reader :cache_dir
  attr_accessor :bindir, :rbdir, :sodir

  def save_file_path(basename)
    File.join(@cache_dir, basename)
  end
  private :save_file_path

  def download_uri(name)
    filepath = save_file_path("raa-#{CGI.escape(name)}.cache.html")
    body = nil
    unless File.exist?(filepath)
      body = get("http://raa.ruby-lang.org/list.rhtml?name=#{name}", filepath)
    else
      body = File.readlines(filepath).join('')
    end
    unless %r!<tr><th>Download: </th>\s*<td><a href="([^\"]+)">! === body
      raise "not found download URI in `RAA - #{name}'"
    end
    $1
  end

  def download(name)
    uri = download_uri(name)
    basename = File.basename(uri)
    filepath = save_file_path(basename)
    if File.exist?(filepath)
      puts "already downloaded: `#{basename}'"
    else
      get(uri, filepath)
    end
    basename
  end

  def chdir(dir)
    old_pwd = Dir.pwd
    Dir.chdir(dir)
    yield
  ensure
    Dir.chdir(old_pwd)
  end

  def system(*cmd)
    puts "system in `#{Dir.pwd}': #{cmd.join(' ')}"
    unless Kernel.system(*cmd)
      raise "system failed: #{cmd.join(' ')}"
    end
  end
  private :system

  def puts(str)
    @fetcher_log ||= File.open(save_file_path('raa-fetcher.log'), 'a')
    @fetcher_log.puts(str)
    Kernel.puts(str)
  end
  private :puts

  def install_start(name)
    puts "===== `#{name}' install start ====="
  end
  private :install_start

  def install_end(name)
    puts "===== `#{name}' install done ====="
  end
  private :install_end

  def extract(filename)
    chdir(@cache_dir) do
      system('tar', 'zxf', filename)
    end
    dir = File.join(@cache_dir, File.basename(filename, '.tar.gz'))
    until File.exist?(dir)
      dir.chop!
    end
    dir
  end
  private :extract

  def install_with_install_rb(name, feature=nil)
    install_start(name)
    filename = download(name)
    package_dir = extract(filename)
    chdir(package_dir) do
      system(RUBY_EXE, 'install.rb')
    end
    install_end(name)
  end

  def install_with_setup_rb(name, feature=nil)
    install_start(name)
    filename = download(name)
    package_dir = extract(filename)
    chdir(package_dir) do
      cmd = [RUBY_EXE, 'setup.rb', 'config']
      cmd << "--bin-dir=#{@bindir}" if @bindir
      cmd << "--rb-dir=#{@rbdir}" if @rbdir
      cmd << "--so-dir=#{@sodir}" if @sodir
      system(*cmd)
      system(RUBY_EXE, 'setup.rb', 'setup')
      system(RUBY_EXE, 'setup.rb', 'install')
    end
    install_end(name)
  end

  def install_file(rb_file)
    dest_file = File.join(@rbdir, rb_file)
    dest_dir = File.dirname(dest_file)
    unless File.exist?(dest_dir)
      File.mkpath(dest_dir.sub(%r!/\.\z!, ''))
    end
    File.install(rb_file, dest_file, 0644, true)
  end
  private :install_file

  def install_by_recursive_copy(name, feature=nil)
    install_start(name)
    filename = download(name)
    package_dir = extract(filename)
    chdir(File.join(package_dir, 'lib')) do
      Dir['**/*.*'].each do |file|
        install_file(file)
      end
    end
    install_end(name)
  end

  def install_by_copy_a_file(name, feature)
    install_start(name)
    filename = download(name)
    package_dir = extract(filename)
    chdir(package_dir) do
      install_file("#{feature}.rb")
    end
    install_end(name)
  end

  def inplace_edit(filename)
    File.open(filename, 'r+') do |f|
      content = f.read
      content = yield(content)
      f.seek(0)
      f.write(content)
      f.truncate(f.tell)
    end
  end

  def patch_ruby_list_38913
    IO.popen("patch -p0", "w") do |f|
      f.write <<-'PATCH'
--- rdtoolconf.rb.~1.23.~	Sat Mar  8 21:45:07 2003
+++ rdtoolconf.rb	Tue Dec 16 00:48:55 2003
@@ -1,15 +1,14 @@
 #!/usr/local/bin/ruby
 # rdtoolconf.rb - create Makefile for rdtool.
      PATCH
      f.write <<-"PATCH"
-\# $\Id: rdtoolconf.rb,v 1.23 2003/03/08 12:45:07 tosh Exp $
+\# $\Id: rdtoolconf.rb,v 1.24 2003/12/15 15:48:55 tosh Exp $
      PATCH
      f.write <<-'PATCH'
 
 require 'mkmf'
 require 'rbconfig'
-require 'amstd/rbparams'
 
 STDERR.print "creating Makefile\n"
 
-$bindir = RubyParams::BINDIR
-$siterubydir = RubyParams::SITE_RB
+$bindir = CONFIG["bindir"]
+$siterubydir = CONFIG["sitedir"]
 $rddir = CONFIG["datadir"] + "/ruby/rd"
 $racc = "racc"
 
@@ -18,6 +17,8 @@
 #
 # RDtool makefile
 
+prefix = #{CONFIG["prefix"]}
+exec_prefix = #{CONFIG["exec_prefix"]}
 BIN_DIR = #{$bindir}
 SITE_RUBY = #{$siterubydir}
 RD_DIR = #{$rddir}
      PATCH
    end
  end

  def install_RDtool(name, feature)
    # check with RDtool 0.6.14
    raise "install_RDtool supports rdtool only: #{name}" if name != 'rdtool'
    install_start(name)
    filename = download(name)
    package_dir = extract(filename)
    chdir(package_dir) do
      #patch_ruby_list_38913
      cmd = [RUBY_EXE]
      cmd << "-I#{@rbdir}" if @rbdir
      cmd << "-I#{@sodir}" if @sodir
      cmd.uniq!
      system(*(cmd+['rdtoolconf.rb']))
      inplace_edit('Makefile') do |makefile|
        makefile.sub!(/^(BIN_DIR = )[^\s]+/, "\\1#{@bindir}") if @bindir
        makefile.sub!(/^(SITE_RUBY = )[^\s]+/, "\\1#{@rbdir}") if @rbdir
        makefile.sub!(/^(RUBY = )[^\s]+/, "\\1#{cmd.join(' ')}") if @rbdir
      end
      system('make', 'all')
      system('make', 'install')
    end
    install_end(name)
  end

end

if __FILE__ == $0
  eval DATA.read, nil, $0, __LINE__+4
end

__END__
require 'runit/testcase'
require 'runit/cui/testrunner'

class TC_RAA_Fetcher < RUNIT::TestCase
  def test_download_uri
    fetcher = RAA_Fetcher.new
    uri = fetcher.download_uri('ruby')
    assert_match(%r!\Aftp://ftp\.ruby-lang\.org/pub/ruby/ruby-\d\.\d\.\d\.tar\.gz\z!, uri)
  end

  def test_install_by_recursive_copy
    fetcher = RAA_Fetcher.new
    fetcher.rbdir = File.join(fetcher.cache_dir, 'test_rb_dir')
    fetcher.install_by_recursive_copy('druby')
  end
end

RUNIT::CUI::TestRunner.run(TC_RAA_Fetcher.suite)
