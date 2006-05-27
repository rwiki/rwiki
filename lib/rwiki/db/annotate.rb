# -*- indent-tabs-mode: nil -*-

require 'time'

module RWiki
  module DB
    class AnnotateLine
      attr_reader :no, :revision, :author, :date, :content
      def initialize(no, revision, author, date, content)
        @no = no
        @revision = revision
        @author = author
        @date = normalize_date(date)
        @content = content
      end

      private
      def normalize_date(val)
        return val if val.nil?
        if val.kind_of?(Time)
          date = val
        else
          date = Time.parse(val)
        end
        date.localtime
      end
    end
  end
end
