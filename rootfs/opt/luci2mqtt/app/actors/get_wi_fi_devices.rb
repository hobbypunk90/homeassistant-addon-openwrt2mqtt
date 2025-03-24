# frozen_string_literal: true

class GetWiFiDevices < Actor
  input :wifi_network

  play Luci::Internal::Login,
       Luci::Internal::GetHostHints,
       Luci::Internal::GetWiFiDevices,
       Internal::ParseWiFiDevices
end
