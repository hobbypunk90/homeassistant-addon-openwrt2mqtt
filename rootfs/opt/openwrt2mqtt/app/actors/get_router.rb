# frozen_string_literal: true

class GetRouter < Actor
  play Luci::Internal::Login,
       Luci::Internal::GetSystemBoard,
       Luci::Internal::GetSystemInfo,
       Internal::ParseBoard,
       Internal::ParseSystemInfo
end
