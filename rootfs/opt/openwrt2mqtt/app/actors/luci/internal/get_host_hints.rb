# frozen_string_literal: true

class Luci::Internal::GetHostHints < Luci::Actor
  prepend WhosGonnaCallMe

  input :auth_token
  output :host_hints

  def call
    self.host_hints = post("cgi-bin/luci/rpc/sys", method: :'net.host_hints')
  end
end
