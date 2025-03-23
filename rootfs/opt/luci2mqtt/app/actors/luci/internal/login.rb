# frozen_string_literal: true

class Luci::Internal::Login < Luci::Actor
  output :auth_token
  def call
    self.auth_token = post('cgi-bin/luci/rpc/auth',
                           method: :login, params: [Settings.luci.username, Settings.luci.password]
    )

    raise StandardError if auth_token.nil?

  rescue StandardError => e
    fail!(error: 'Login failed')
    raise e
  end
end
