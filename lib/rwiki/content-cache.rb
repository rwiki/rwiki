# -*- indent-tabs-mode: nil -*-

require 'rwiki/page'
require 'digest/md5'

module RWiki
  class ContentCache
    def initialize(dir="cache")
      @dir = dir
      @mkdir = false
    end

    def start
      return if @mkdir
      @mkdir = true
      Dir.mkdir(@dir)
    rescue Errno::EEXIST
    end

    def fetch(name, filename, sign)
      File.open(filename, 'rb') do |f|
        return nil unless name == Marshal.load(f)
        return nil unless sign == Marshal.load(f)
        return Marshal.load(f)
      end
    rescue
      nil
    end
    
    def store(name, filename, sign, obj)
      File.open(filename, 'wb') do |f|
        Marshal.dump(name, f)
        Marshal.dump(sign, f)
        Marshal.dump(obj, f)
      end
    rescue
      unlink(filename)
    end

    def get(name, src)
      return yield(name, src) if src.nil?

      filename, sign = make_filename_and_sign(name, src)
      filename = File.join(@dir, filename)
      obj = fetch(name, filename, sign)

      unless obj
        obj = yield(name, src)
        store(name, filename, sign, obj)
      end
      obj
    end

    def make_filename_and_sign(name, src)
      md5 = Digest::MD5.new

      md5.update(name)
      filename = md5.hexdigest
      
      md5.update(src)
      sign = md5.hexdigest

      [filename, sign]
    end
  end

  class NullContentCache
    def start; end

    def get(name, src)
      yield(name, src)
    end
  end
end
