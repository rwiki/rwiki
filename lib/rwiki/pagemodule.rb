# -*- indent-tabs-mode: nil -*-

module RWiki
  # default page modules
  PageModule = []

  def self.install_page_module(name, format, title=nil)
    PageModule.push([name, format, title])
  end
end
