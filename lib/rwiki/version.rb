module RWiki
  module Version
    @list = []

    def each
      @list.each do |name, version|
        version = version.call if version.respond_to?(:call)
        yield(name, version)
      end
    end

    def regist(name, version=nil)
      version ||= Proc.new
      @list.push([name, version])
    end

    module_function :each, :regist
  end

  Version.regist('ruby (server side)',
                 "#{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]")
end
