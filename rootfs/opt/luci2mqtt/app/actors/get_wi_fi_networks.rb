# frozen_string_literal: true

class GetWiFiNetworks < Actor
  play Luci::Internal::Login,
       Luci::Internal::GetWiFiNetworks,
       Internal::ParseWiFiNetworks
end
