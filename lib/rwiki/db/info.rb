# -*- indent-tabs-mode: nil -*-

require 'monitor'
require "fileutils"
require "yaml"

module RWiki
  module DB
    module Info
      include MonitorMixin
      
      def initialize(path, base_name)
        @base_dir = base_dir(path)
        @base_name = base_name
        @info = default_info
        @timestamp = nil
        super()
        refresh
      end

      private
      def base_dir(path)
        info_path = ::File.join(path.split(::File::Separator) + ["info"])
        FileUtils.mkdir_p(info_path)
        info_path
      end
      
      def file_name
        @file_name ||= ::File.join(@base_dir, "#{@base_name}.yaml")
      end

      def refresh
        if need_refresh?
          synchronize do
            ::File.open(file_name) do |f|
              refresh_info(f)
            end
            update_timestamp!
          end
        end
      end

      def store
        synchronize do
          ::File.open(file_name, "w") do |f|
            store_info(f)
          end
          update_timestamp!
        end
      end
      
      def update_timestamp!
        if ::File.exist?(file_name)
          @timestamp = ::File.mtime(file_name)
        else
          @timestamp = nil
        end
      end
      
      def need_refresh?
        ::File.exist?(file_name) and
          (@timestamp.nil? or ::File.mtime(file_name) > @timestamp)
      end

      def refresh_info(input)
        @info = YAML.load(input)
      end

      def store_info(output)
        output.print(@info.to_yaml)
      end

    end
  end
end
