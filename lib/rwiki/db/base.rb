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
        k = arg.shift
        v = arg.pop
        rev = arg.shift
        opt = arg.shift
        check_revision(k, rev)
        set(k, store(v))
      end

      def [](k)
        retrieve(get(k))
      end

      def modifed(k)
        nil
      end

      def revision(k)
        modified(k).to_s
      end


      def logs(k)
        []
      end
      
      def diff(k, rev1, rev2)
        nil
      end

      def each
        ;
      end

      def check_revision(k, rev)
        return unless rev
        unless rev == revision(k)
          raise RevisionError, "Source revision mismatch." # [rev, revision(k)].inspect
        end
      end

      private
      def store(s)
        s
      end

      def retrieve(s)
        s
      end
    end
  end
end
