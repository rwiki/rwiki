require "erb"

module RWiki

  Version.regist('rwiki/hooks', '$Id$')

  module Hooks
    @@header_hooks = []

    module_function
    def install_header_hook(hook)
      @@header_hooks << hook
    end
    def header_hooks
      @@header_hooks
    end

    class Hook
      include ERB::Util
    end
  end
end
