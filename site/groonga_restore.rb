require 'fileutils'
require 'groonga'

dump = ARGV.shift
dir = ARGV.shift || 'groonga_db'

data = File.read(dump)
data.force_encoding('utf-8')
FileUtils::mkdir_p(dir)
Groonga::Database.create(:path => ::File.join(dir, 'rwiki.groonga'))
Groonga::Context.default.restore(data)
