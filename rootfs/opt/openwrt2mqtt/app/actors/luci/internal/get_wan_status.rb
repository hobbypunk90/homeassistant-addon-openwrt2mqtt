# frozen_string_literal: true

class Luci::Internal::GetWanStatus < Luci::Actor
  prepend WhosGonnaCallMe

  input :ubus_session
  output :wan_status
  output :wan_ipv4_address

  def call
    response = ubus(:call, [:'luci.internet-detector', :InetStatus, {}])
    return if response[:error].present?

    self.wan_status = response[:result].second[:instances].first
  end
end
