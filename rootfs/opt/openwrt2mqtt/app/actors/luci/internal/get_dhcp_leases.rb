# frozen_string_literal: true

class Luci::Internal::GetDhcpLeases < Luci::Actor
  prepend WhosGonnaCallMe

  input :auth_token
  output :dhcp_static_leases

  def call
    self.dhcp_static_leases = post('cgi-bin/luci/rpc/uci', method: :get_all, params: [:dhcp])
                                .filter { |_key, value| value['.type'] == 'host' }.values
  end
end
