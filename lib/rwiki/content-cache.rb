# -*- indent-tabs-mode: nil -*-

require 'rwiki/page'
require 'digest/sha1'
require 'fileutils'

module RWiki
  class ContentCache
    def initialize(dir="cache")
      @dir = dir
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
      FileUtils.mkdir_p(File.dirname(filename))
      File.open(filename, 'wb') do |f|
        Marshal.dump(name, f)
        Marshal.dump(sign, f)
        Marshal.dump(obj, f)
      end
    rescue
      File.unlink(filename)
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
      digest = Digest::SHA1.new

      digest.update(name)
      filename = digest.hexdigest
      filename[2, 0] = '/'

      digest.update(src)
      sign = digest.hexdigest

      [filename, sign]
    end
  end

  class NullContentCache
    def get(name, src)
      yield(name, src)
    end
  end
end
