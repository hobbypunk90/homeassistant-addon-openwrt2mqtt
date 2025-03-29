# frozen_string_literal: true

class LoadAll < ApplicationActor
  play GetRouter,
       GetWiFiNetworks,
       Luci::Internal::GetHostHints,
       Luci::Internal::GetDhcpLeases,
       -> (actor) do
         actor.router.wifi_networks.each do |wifi_network|
           GetWiFiDevices.call(auth_token: actor.auth_token,
                               host_hints: actor.host_hints,
                               dhcp_static_leases: actor.dhcp_static_leases,
                               wifi_network:)
         end
       end
end
