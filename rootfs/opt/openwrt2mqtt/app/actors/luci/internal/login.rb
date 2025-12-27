# frozen_string_literal: true

class Luci::Internal::Login < Luci::Actor
  prepend WhosGonnaCallMe

  output :auth_token
  output :ubus_session
  def call
    self.auth_token = post("cgi-bin/luci/rpc/auth",
                           method: :login, params: [Settings.openwrt.username, Settings.openwrt.password]
    )
    self.ubus_session = ubus(:call, [
      :session, :login,
      { username: Settings.openwrt.username, password: Settings.openwrt.password }
    ])[:result].second[:ubus_rpc_session]

    raise StandardError if auth_token.nil?
  rescue StandardError => e
    fail!(error: "Login failed")
    raise e
  end
end
