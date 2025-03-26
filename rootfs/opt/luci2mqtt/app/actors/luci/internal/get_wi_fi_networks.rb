# frozen_string_literal: true

class Luci::Internal::GetWiFiNetworks < Luci::Actor
  prepend WhosGonnaCallMe

  input :auth_token
  output :plain_text_networks

  def call
    self.plain_text_networks = post('cgi-bin/luci/rpc/sys', method: :exec, params: ['iwinfo']).split("\n\n")
  end
end
