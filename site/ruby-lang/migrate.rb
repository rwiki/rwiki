#!/usr/bin/ruby

require 'fileutils'
require 'iconv'

class FilenameMigrate
  def initialize(fromcode, tocode, notest)
    @fromcode = fromcode
    @tocode = tocode
    @notest = notest
    if notest
      @FileUtils = FileUtils::Verbose
    else
      @FileUtils = FileUtils::DryRun
    end
  end

  private

  def escape(str)
    str.gsub(/([^a-zA-Z0-9_-])/n){ sprintf("%%%02X", $1.unpack("C")[0]) }
  end

  def unescape(str)
    str.tr('+', ' ').gsub(/((?:%[0-9a-fA-F]{2})+)/n) do
      [$1.delete('%')].pack('H*')
    end
  end

  def convert_filename(filename)
    filename.sub(/[^.]+/) do
      escape(Iconv.conv(@tocode, @fromcode, unescape($&)))
    end
  end

  public

  def migrate_entries
    entries = "CVS/Entries"
    tmppath = "CVS/Entries.migrate.tmp"
    File.open(entries, "rb") do |infile|
      File.open(tmppath, "wb") do |outfile|
        infile.each do |line|
          array = line.split(/(\/)/, 3)
          # array = [filetype, '/', filename, '/', rest]
          if array[2]
            array[2] = convert_filename(array[2])
          end
          outfile.print array.join('')
        end
      end
    end
    @FileUtils.mv(tmppath, entries)
  end

  def migrate_filenames(dir='.')
    Dir.entries(dir).each do |fname|
      src = File.join(dir, fname)
      next if File.directory?(src)
      next if /\.tmp\z/ =~ src
      tmp = src + ".tmp"
      dst = File.join(dir, convert_filename(fname))
      File.open(src, "rb") do |infile|
        File.open(tmp, "wb") do |outfile|
          indata = infile.read
          # http://www.namazu.org/~satoru/diary/20030815.html
          iconv = Iconv.new(@tocode, @fromcode)
          begin
            outfile << iconv.iconv(indata)
          rescue Iconv::IllegalSequence => e
            outfile << e.success
            indata = e.failed
            indata[0] = ??
            retry
          end
        end
      end
      @FileUtils.mv(tmp, dst)
      if src != dst
        @FileUtils.rm_f(src)
      end
    end
  end
end

if __FILE__ == $0
  require 'optparse'
  opt = OptionParser.new("Usage: #{$0} [options] cvs-working-copy-data-directory")
  #fromcode = 'euc-jp-ms'
  fromcode = 'euc-jp'
  opt.on('-f FROMCODE') {|v| fromcode=v}
  tocode = 'utf-8'
  opt.on('-t TOCODE') {|v| tocode=v}
  notest = false
  opt.on('--notest', 'do migrate') {|v| notest=v}
  opt.parse!(ARGV)
  wc = ARGV.shift
  unless wc
   puts opt
   exit(false)
  end
  Dir.chdir(wc)
  m = FilenameMigrate.new(fromcode, tocode, notest)
  m.migrate_entries
  m.migrate_filenames
  cvsroot = File.read('CVS/Root').chomp.chomp
  cvsrepo = File.read('CVS/Repository').chomp.chomp
  repodir = File.join(cvsroot, cvsrepo)
  puts repodir
  m.migrate_filenames(repodir)
end
