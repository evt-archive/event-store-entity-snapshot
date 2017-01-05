ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_COLOR'] ||= 'on'

if ENV['LOG_LEVEL']
  ENV['LOGGER'] ||= 'on'
else
  ENV['LOG_LEVEL'] ||= 'trace'
end

ENV['LOGGER'] ||= 'off'
ENV['LOG_OPTIONAL'] ||= 'off'
ENV['ENTITY_CACHE_SCOPE'] ||= 'exclusive'

ENV['DISABLE_EVENT_STORE_LEADER_DETECTION'] ||= 'on'

puts RUBY_DESCRIPTION

require_relative '../init.rb'

require 'securerandom'
require 'test_bench'; TestBench.activate
require 'event_store/entity_snapshot/controls'

Telemetry::Logger::AdHoc.activate
