# -*- indent-tabs-mode: nil -*-

begin
  require "rwiki/gettext/available"
rescue LoadError
  require "rwiki/gettext/fallback"
end

module RWiki
  extend GetText
end
