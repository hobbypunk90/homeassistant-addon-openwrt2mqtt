# frozen_string_literal: true

class Luci::Internal::GetWanInterfaces < Luci::Actor
  prepend WhosGonnaCallMe

  input :ubus_session
  output :wan_interfaces

  def call
    response = ubus(:call, [:mwan3, :status, {}])
    return if response[:error].present?

    self.wan_interfaces = response[:result].second[:interfaces]

    response = ubus(:call, [:'luci.internet-detector', :InetStatus, {}])
    return if response[:error].present?

    instances = response[:result].second[:instances]
    self.wan_interfaces.each_key do |interface|
      self.wan_interfaces[interface][:public_ip] = instances.find { |i| i[:instance] == interface }&.fetch(:mod_public_ip, nil)
    end
    response[:result].second[:instances]
  end
end
