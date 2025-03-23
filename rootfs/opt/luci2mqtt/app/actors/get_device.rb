# frozen_string_literal: true

class GetDevice < Actor
  play Luci::Internal::Login,
       Luci::Internal::GetSystemBoard,
       Luci::Internal::GetSystemInfo,
       Internal::ParseBoard,
       Internal::ParseSystemInfo
end
