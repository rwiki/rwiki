require "test/unit"

require 'webrick/httputils'

module Kernel
  unless methods.include?("funcall")
    def funcall(*args, &block)
      __send__(*args, &block)
    end
  end
end

module RWTestUtil
  def form_data(*args)
    WEBrick::HTTPUtils::FormData.new(*args)
  end
end
