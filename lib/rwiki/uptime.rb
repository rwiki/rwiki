# -*- indent-tabs-mode: nil -*-

require 'rwiki/format'

module RWiki
  BOOT_TIME = Time.now
  Version.register('rwiki/uptime') do
    ModifiedFormatter.modified(BOOT_TIME)
  end
end
