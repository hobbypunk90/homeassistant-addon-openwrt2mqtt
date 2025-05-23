# frozen_string_literal: true

class Luci::Internal::Login < Luci::Actor
  prepend WhosGonnaCallMe

  output :auth_token
  def call
    self.auth_token = post("cgi-bin/luci/rpc/auth",
                           method: :login, params: [Settings.openwrt.username, Settings.openwrt.password]
    )

    raise StandardError if auth_token.nil?
  rescue StandardError => e
    fail!(error: "Login failed")
    raise e
  end
end
