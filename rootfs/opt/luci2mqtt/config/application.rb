# frozen_string_literal: true

require_relative 'environment'

result = GetDevice.result

exit(1) unless result.success?

puts "#{result.device}\n"

puts "#{result.device.wifi_networks.join("\n")}"
