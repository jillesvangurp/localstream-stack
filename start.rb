#!/usr/bin/env ruby

require 'lib/enable_java'

raise("Fishwife only runs on JRuby.") unless (RUBY_PLATFORM =~ /java/)

require 'fishwife'
require 'rjack-slf4j/nop'

server = Rack::Server.new
server.options[:server] = 'Fishwife'
server.start