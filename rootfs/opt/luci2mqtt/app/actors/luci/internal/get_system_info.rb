# frozen_string_literal: true

class Luci::Internal::GetSystemInfo < Luci::Actor
  prepend WhosGonnaCallMe

  input :auth_token
  output :system_info

  def call
    self.system_info = JSON.parse(post('cgi-bin/luci/rpc/sys', method: :exec, params: ['ubus call system info']))
                           .with_indifferent_access
  end
end
