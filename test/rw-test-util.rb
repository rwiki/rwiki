require "test/unit"

require 'webrick/httputils'

module RWTestUtil
  def form_data(*args)
    WEBrick::HTTPUtils::FormData.new(*args)
  end
end
