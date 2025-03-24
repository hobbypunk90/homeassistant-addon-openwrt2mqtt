# frozen_string_literal: true

require_relative 'environment'

result = GetRouter.result
exit(1) unless result.success?

router = result.router
puts "#{router}\n"
puts "#{router.wifi_devices.size}\n"

wifi_network = router.wifi_networks[4]
puts "#{wifi_network}"

puts "#{wifi_network.wifi_devices.join("\n\n")}"
