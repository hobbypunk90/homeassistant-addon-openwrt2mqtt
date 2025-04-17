# frozen_string_literal: true

class Luci::Internal::GetLatestVersionData < Luci::Actor
  prepend WhosGonnaCallMe

  output :latest_version_data

  def call
    self.latest_version_data = JSON.parse(Faraday.get(Settings.openwrt.sysupgrade.url).body)
                                   .with_indifferent_access
  end
end
