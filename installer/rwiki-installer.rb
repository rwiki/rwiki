#!/usr/bin/env ruby
# RWikiと依存ライブラリのインストーラ
# copyright (c) 2003- Kazuhiro NISHIYAMA
# You can redistribute it and/or modify it under the same term as Ruby.

require 'etc'
require 'getopts'
require 'raa-fetcher'
require 'socket'

def parse_options
  getopts(*(%w[
            h help rbconfig force
            prefix: bindir: rbdir: sodir:
            sitedir: webdir:
            localedir:
            rw-config-file:
            address: mailto:
            rw-css: rw-lang: rw-charset:
            rw-dbdir: rw-top-name: rw-title: rw-drb-uri:
            icon: icon-type:

            daemon-file:
            pid-file:
            rw-option:
            initd-file:

            cgi-file:
            cgi-option: cgi-log-dir:

            cache-dir: proxy:
          ].collect{|str|
            if RUBY_VERSION < '1.6.8'
              str.tr('-','_')
            else
              str
            end
          }))

  $OPT_prefix ||= File.expand_path('rwiki2', ENV['HOME'])
  $OPT_bindir ||= File.expand_path('bin', $OPT_prefix)
  $OPT_rbdir ||= File.expand_path('lib', $OPT_prefix)
  $OPT_sodir ||= File.expand_path('lib', $OPT_prefix)

  $OPT_sitedir ||= File.expand_path('site', $OPT_prefix)
  $OPT_webdir ||= File.expand_path(File.join('public_html', 'rwiki2'), $OPT_prefix)
  $OPT_localedir ||= File.expand_path('share/locale', $OPT_prefix)

  $OPT_rw_config_file ||= 'rw-config.rb'
  $OPT_address ||= Etc.getpwnam(Etc.getlogin).gecos.split(/,/)[0] || Etc.getlogin
  $OPT_mailto ||= 'mailto:' + (ENV['EMAIL'] ||
    Etc.getlogin + '@' + Socket.gethostname)
  $OPT_rw_css ||= nil
  $OPT_rw_lang ||= nil
  $OPT_rw_charset ||= nil

  $OPT_rw_dbdir ||= '../rd'
  $OPT_rw_top_name ||= 'top'
  $OPT_rw_title ||= 'RWiki'
  $OPT_rw_drb_uri ||= 'druby://localhost:8470'
  $OPT_icon ||= nil
  $OPT_icon_type ||= nil

  $OPT_daemon_file ||= 'rwiki-daemon.rb'
  $OPT_pid_file ||= File.expand_path(File.join('site', 'rwiki.pid'), $OPT_prefix)
  $OPT_rw_option ||= '-Ke'
  $OPT_initd_file ||= 'run-rwiki.sh'

  $OPT_cgi_file ||= 'rw.cgi'
  $OPT_cgi_option ||= $OPT_rw_option
  $OPT_cgi_log_dir ||= File.expand_path('log', $OPT_prefix)

  $OPT_cache_dir ||= File.expand_path('cache', Dir.pwd)
  $OPT_proxy ||= ENV['http_proxy']

  if $OPT_h or $OPT_help
    usage = <<-USAGE
usage: #{$0} [switches] install
  --help, -h    print this message
 destination directories:
  --rbconfig    use default of rbconfig instead of
                prefix (bindir, rbdir, sodir)
  --prefix      (default: $HOME/rwiki2) (#{$OPT_prefix.inspect})
  --bindir      (default: $PREFIX/bin) (#{$OPT_bindir.inspect})
  --rbdir       (default: $PREFIX/lib) (#{$OPT_rbdir.inspect})
  --sodir       (default: $PREFIX/lib) (#{$OPT_sodir.inspect})
  --sitedir     RWiki daemon directory (default: $PREFIX/site) (#{$OPT_sitedir.inspect})
  --webdir      (default: $PREFIX/public_html/rwiki2) (#{$OPT_webdir.inspect})
  --localedir   (default: $PREFIX/share/locale) (#{$OPT_localedir.inspect})
 rw-config.rb options:
  --rw-config-file	rw-config.rb filename (default: rw-config.rb) (#{$OPT_rw_config_file})
  --address     RWiki::ADDRESS (default:
                  Etc.getpwnam(Etc.getlogin).gecos.split(/,/)[0] ||
                  Etc.getlogin) (#{$OPT_address.inspect})
  --mailto      RWiki::MAILTO (default: ENV['EMAIL'] ||
                  Etc.getlogin + '@' + Socket.gethostname)
                  (#{$OPT_mailto.inspect})
  --rw-css      RWiki::CSS (default: nil) (#{$OPT_rw_css.inspect})
  --rw-lang     RWiki::LANG (default: nil) (#{$OPT_rw_lang.inspect})
  --rw-charset  RWiki::CHARSET (default: nil) (#{$OPT_rw_charset.inspect})
  --rw-dbdir    RWiki::DB_DIR (default: '../rd') (#{$OPT_rw_dbdir.inspect})
  --rw-top-name RWiki::TOP_NAME (default: 'top') (#{$OPT_rw_top_name.inspect})
  --rw-title    RWiki::TITLE (default: 'RWiki') (#{$OPT_rw_title.inspect})
  --rw-drb-uri  RWiki::DRB_URI (default: 'druby://localhost:8470') (#{$OPT_rw_drb_uri.inspect})
  --icon        RWiki::ICON (favicon URL) (default: nil) (#{$OPT_icon.inspect})
  --icon-type   RWiki::ICON_TYPE (favicon MIME-type) (default: nil (means 'image/x-icon')) (#{$OPT_icon_type.inspect})
 rwiki-daemon.rb options:
  --daemon-file RWiki daemon file name (default: rwiki-daemon.rb) (#{$OPT_daemon_file.inspect})
  --pid-file    RWiki daemon pid file (default: $PREFIX/site/rwiki.pid) (#{$OPT_pid_file.inspect})
  --rw-option   RWiki daeamon shebang line option (default: '-Ke') (#{$OPT_rw_option.inspect})
 run-rwiki.sh options:
  --initd-file  script for start/stop RWiki daemon (default: run-rwiki.sh) (#{$OPT_initd_file.inspect})
 rw.cgi options:
  --cgi-file  RWiki cgi file name (default: rw.cgi) (#{$OPT_cgi_file.inspect})
  --cgi-option  RWiki cgi shebang line option (default: rw-option) (#{$OPT_cgi_option.inspect})
  --cgi-log-dir RWiki cgi log directory (default: $PREFIX/log) (#{$OPT_cgi_log_dir.inspect})
 downloader option:
  --cache-dir   cache directory (default: './cache') (#{$OPT_cache_dir.inspect})
  --proxy       proxy uri (default: ENV['http_proxy']) (#{$OPT_proxy.inspect})
    USAGE
    if RUBY_VERSION < '1.6.8'
      usage.gsub!(/^  --([a-z\-]+)/) {
        "  --#{$1.tr('-','_')}"
      }
    end
    puts usage
    exit(-1)
  end

  unless $OPT_rbconfig
    [$OPT_rbdir, $OPT_sodir].uniq.each do |dir|
      unless $LOAD_PATH.include?(dir)
        puts "warning: `#{dir}' is not in LOAD_PATH, added"
        $LOAD_PATH.push dir
        # set RUBYLIB for `require' in the racc command
        ENV['RUBYLIB'] = ENV['RUBYLIB'].to_s + ':' + dir
      end
    end

    path_separator =
      if ENV['PATH'].include?(';')
        ';'
      else
        ':'
      end
    unless ENV['PATH'].split(/#{Regexp.quote(path_separator)}/).include?($OPT_bindir)
      puts "warning: `#{$OPT_bindir}' is not in $PATH, added"
      ENV['PATH'] += "#{path_separator}#{$OPT_bindir}"
    end
  end
end

def fetch_libraries
  fetcher = RAA_Fetcher.new($OPT_cache_dir, {}, $OPT_proxy)
  unless $OPT_rbconfig
    fetcher.bindir = $OPT_bindir
    fetcher.rbdir = $OPT_rbdir
    fetcher.sodir = $OPT_sodir
  end
  install_with_install_rb = fetcher.method(:install_with_install_rb)
  install_by_recursive_copy = fetcher.method(:install_by_recursive_copy)
  install_rb_or_copy =
    if $OPT_rbconfig
      install_with_install_rb
    else
      install_by_recursive_copy
    end
  install_with_setup_rb = fetcher.method(:install_with_setup_rb)
  install_by_copy_a_file = fetcher.method(:install_by_copy_a_file)
  install_parent_dir_rwiki_or_fetch = proc do |raa_name, feature|
    if File.exist?("../install.rb")
      fetcher.chdir("..") do
        system(RAA_Fetcher::RUBY_EXE, "install.rb", "-d", $OPT_rbdir)
      end
    else
      install_rb_or_copy.call(raa_name, feature)
    end
  end

  [
    ['logger', 'devel-logger', install_rb_or_copy],
    # ['devel/logger', 'devel-logger', install_rb_or_copy],
    ['drb/drb', 'druby', install_rb_or_copy],
    ['erb', nil, install_rb_or_copy],
    ['rwiki/rw-lib', 'rwiki', install_parent_dir_rwiki_or_fetch],
    # ['mutexm', 'mutexm', install_rb_or_copy], # do not need
    ['racc/compiler', 'racc', install_with_setup_rb],
    ['optparse', 'optionparser', install_by_copy_a_file],
    ['forwardable', nil, install_by_copy_a_file],
    ['rd/tree', 'rdtool', fetcher.method(:install_RDtool)],
    # ['rt/rt2txt-lib', 'rttool', install_with_setup_rb], # RWikiに添付
  ].each do |feature, raa_name, install_proc|
    raa_name ||= feature
    begin
      require feature
      puts "found: `#{raa_name}'"
    rescue LoadError
      install_proc.call(raa_name, feature)
      require feature
    end
  end
end

def copy_templates
  File.umask(022)
  {
    $OPT_sitedir =>
    [
      'crontab.sample',
      ['rw-config.rb', $OPT_rw_config_file, 0644],
      ['rwiki-daemon.rb', $OPT_daemon_file, 0755],
      ['run-rwiki.sh', $OPT_initd_file, 0755],
    ],
    $OPT_webdir =>
    [
      'rwiki.css',
      ['rw.cgi', $OPT_cgi_file, 0755],
    ],
  }.each do |dest_dir, files|
    File.mkpath(dest_dir)
    files.each do |filename, dest_filename, mode|
      dest_filename ||= filename
      src_path = "#{filename}.erb"
      dst_path = File.expand_path(dest_filename, dest_dir)
      puts "#{src_path} -> #{dst_path}"
      erb = File.open(src_path) {|f| ERB.new(f.read)}
      File.open(dst_path, 'w') do |f|
        begin
          f.write erb.result
        rescue StandardError, NameError
          $stderr.puts "error in #{filename}.erb"
          raise
        end
        if mode
          puts(sprintf("chmod %#0o %s", mode, dst_path))
          f.chmod(mode)
        end
      end
    end
  end
end

def copy_mo
  po_dir = '../po'
  Dir.entries(po_dir).grep(/mo\z/).each do |mo|
    mo_file = File.expand_path(mo, po_dir)
    locale = File.basename(mo, '.mo')
    lc_messages_dir = File.expand_path("#{locale}/LC_MESSAGES", $OPT_localedir)
    rwiki_mo = File.join(lc_messages_dir, 'rwiki.mo')
    File.mkpath(lc_messages_dir)
    File.install(mo_file, rwiki_mo, 0644, true)
  end
end

def make_directories
  [
    File.expand_path($OPT_rw_dbdir, $OPT_sitedir),
    File.expand_path('ext', $OPT_sitedir),
    $OPT_cgi_log_dir,
  ].each do |dir|
    puts "mkdir -p #{dir}"
    File.mkpath(dir)
  end
end

def finish_message
  puts <<-MESSAGE

Install finished.

Please run `#{$OPT_sitedir}/#{$OPT_initd_file} start',
and access `#{$OPT_webdir}/#{$OPT_cgi_file}'
via web server.

Note: You can copy the files under `#{$OPT_webdir}'
      to any directory, and they work.
Note: When you want to install same options again,
      see comments in `#{$OPT_sitedir}/rwiki-daemon.rb'.
  MESSAGE
end

if __FILE__ == $0
  case ARGV[-1]
  when 'install'
    ARGV.pop
  else
    ARGV.unshift '-h'
  end
  $ARGV_orig = ARGV.dup
  parse_options
  fetch_libraries
  copy_templates
  copy_mo
  make_directories
  finish_message
end
