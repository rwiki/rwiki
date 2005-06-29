# rw-drb.rb
#
# Copyright (c) 2000 Masatoshi SEKI
#
# rw-drb.rb is copyrighted free software by Masatoshi SEKI.
# You can redistribute it and/or modify it under the same terms as Ruby.

require 'drb/drb'
require 'erb'

if __FILE__ == $0
  DRb.start_service()

  it = ARGV.shift || 'druby'
  drb_uri = ARGV.shift || 'druby://localhost:8470'
  rwiki = DRbObject.new_with_uri(drb_uri)

  p rwiki.find(it)
  rwiki.find_all(it) do |pg|
    p pg.name
  end

  p rwiki.include?(it)

  puts rwiki.body('top')

  # drb-2.0 feature
  top = DRbObject.new_with_uri("#{drb_uri}?top")
  p top.name
  puts top.src
  
  erb = top.body_erb
  p erb
end
