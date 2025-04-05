# frozen_string_literal: true

class GetWiFiNetworks < Actor
  input :auth_token, allow_nil: true, default: nil

  play Luci::Internal::Login, if: ->(actor) { actor.auth_token.nil? }
  play Luci::Internal::GetWiFiNetworks,
       Internal::ParseWiFiNetworks
end
