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

      def accept_commit_log?
        false
      end
      
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

      def modified(key)
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
        if rev1.nil? and rev2
          diff_from_epoch(key, rev2)
        else
          diff_between(key, rev1, rev2)
        end
      end

      def move(old, new, src=nil, rev=nil, opt=nil)
        self[new, nil, opt] = (src || self[old, rev])
        self[old, nil, opt] = ""
      end

      def annotate(name, rev=nil)
        []
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

      def gc
        ;
      end

      def protect_key_supported?
        false
      end

      def trap_field_supported?
        false
      end

      def protect_key
        ""
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

      def diff_from_epoch(key, rev)
        nil
      end
      
      def diff_between(key, rev1, rev2)
        nil
      end
    end
  end
end
