# frozen_string_literal: true

class Luci::Internal::GetWiFiDevices < Luci::Actor
  prepend WhosGonnaCallMe

  input :auth_token
  input :wifi_network
  output :plain_text_devices

  def call
    response = post('cgi-bin/luci/rpc/sys', method: :exec, params: ["iwinfo #{wifi_network.device} assoclist"])
                 .strip
    if(response == 'No station connected')
      self.plain_text_devices = []
    else
      self.plain_text_devices = response.split("\n\n")
    end
  end
end
