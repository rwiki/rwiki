require "erb"

module RWiki

  Version.regist('rwiki/hooks', '$Id$')

  module Hooks
    module_function
    def setup_hook(name, file=__FILE__, line=__LINE__)
      module_eval(<<-EOC, file, line)
      @@#{name}_hooks = []

      module_function
      def install_#{name}_hook(hook)
        @@#{name}_hooks << hook
      end

      def #{name}_hooks
        @@#{name}_hooks
      end
EOC
    end

    setup_hook(:header, __FILE__, __LINE__)
    setup_hook(:close, __FILE__, __LINE__)

    class Hook
      include ERB::Util
    end
  end
end
