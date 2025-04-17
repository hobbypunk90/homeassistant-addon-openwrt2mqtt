# frozen_string_literal: true

class GetRouter < Actor
  play Luci::Internal::Login,
       Luci::Internal::GetSystemBoard,
       Luci::Internal::GetSystemInfo,
       Luci::Internal::GetLatestVersionData,
       Internal::GetRouter,
       Internal::ParseBoard,
       Internal::ParseSystemInfo,
       Internal::ParseLatestVersionData
end
