# frozen_string_literal: true

class LoadAll < Actor
  play GetRouter,
       GetWiFiNetworks,
       Luci::Internal::GetHostHints,
       -> (actor) do
         actor.router.wifi_networks.each do |wifi_network|
           GetWiFiDevices.call(auth_token: actor.auth_token, host_hints: actor.host_hints, wifi_network:)
         end
       end
end
