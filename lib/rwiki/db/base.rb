# -*- indent-tabs-mode: nil -*-
# rwiki/db/base.rb
#
# Copyright (c) 2000-2003 Masatoshi SEKI
#
# rwiki/db/base.rb is copyrighted free software by Masatoshi SEKI.
# You can redistribute it and/or modify it under the same term as Ruby.

require 'rwiki/rw-lib'
require 'rwiki/db/log'

module RWiki
  module DB
    class Base
      include Enumerable

      def []=(*arg)
        key = arg.shift
        value = arg.pop
        rev = arg.shift
        opt = arg.shift
        check_revision(key, rev)
        set(key, store(value), opt)
      end

      def [](key, rev=nil)
        retrieve(get(key, rev))
      end

      def modifed(key)
        nil
      end

      def revision(key)
        modified(key).to_s
      end


      def logs(key)
        []
      end
      
      def log(key, rev=nil)
        nil
      end
      
      def diff(key, rev1, rev2)
        nil
      end

      def each
        ;
      end

      def check_revision(key, rev)
        return unless rev
        unless rev == revision(key)
          raise RevisionError, "Source revision mismatch." # [rev, revision(key)].inspect
        end
      end

      def close
        ;
      end
      
      private
      def store(value)
        if value.nil? or value.empty?
          value
        elsif /\A\s+\z/ =~ value
          ''
        else
          value = value.dup
          value.sub!(/\n?\z/,"\n")
          value
        end
      end

      def retrieve(value)
        value
      end
    end
  end
end
