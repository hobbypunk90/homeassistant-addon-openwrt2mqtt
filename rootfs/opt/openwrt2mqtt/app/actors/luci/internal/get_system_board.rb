# frozen_string_literal: true

class Luci::Internal::GetSystemBoard < Luci::Actor
  prepend WhosGonnaCallMe

  input :auth_token
  output :board

  def call
    self.board = JSON.parse(post("cgi-bin/luci/rpc/sys", method: :exec, params: ["ubus call system board"]))
                   .with_indifferent_access
  end
end
