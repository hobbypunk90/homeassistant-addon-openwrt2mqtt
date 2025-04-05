# frozen_string_literal: true

class GetWiFiDevices < Actor
  input :auth_token, allow_nil: true, default: nil
  input :host_hints, allow_nil: true, default: nil
  input :dhcp_static_leases, allow_nil: true, default: nil
    input :wifi_network

  play Luci::Internal::Login, if: ->(actor) { actor.auth_token.nil? }
  play Luci::Internal::GetHostHints, if: ->(actor) { actor.host_hints.nil? }
  play Luci::Internal::GetDhcpLeases, if: ->(actor) { actor.dhcp_static_leases.nil? }
  play Luci::Internal::GetWiFiDevices,
       Internal::ParseWiFiDevices
end
