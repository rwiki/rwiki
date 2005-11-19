# -*- indent-tabs-mode: nil -*-

require "erb"

module RWiki

  class ERBLoader
    def initialize(method_name, fname, dir=nil)
      @dir = dir
      @fname = fname
      @method_name = method_name
    end

    def load(mod)
      reload(mod)
    end

    def reload(mod)
      fname = build_fname(@fname, @dir)
      erb = File.open(fname) {|f| ERB.new(f.read)}
      erb.def_method(mod, @method_name, fname)
    end

    private
    def build_fname(fname, dir)
      case dir
      when String
        ary = [dir]
      when Array
        ary = dir
      else
        ary = $:
      end

      found = fname # default
      ary.each do |dir|
        path = File::join(dir, fname)
        if File::readable?(path)
          found = path
          break
        end
        path = File::join(dir, 'rwiki', fname)
        if File::readable?(path)
          found = path
          break
        end
      end
      found
    end
  end

end
