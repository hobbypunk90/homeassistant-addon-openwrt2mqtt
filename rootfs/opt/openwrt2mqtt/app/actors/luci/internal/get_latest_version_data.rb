# frozen_string_literal: true

class Luci::Internal::GetLatestVersionData < Luci::Actor
  prepend WhosGonnaCallMe

  output :latest_version_data

  def call
    body = Faraday.new { |conn| conn.options.timeout = 5 }.get(Settings.openwrt.sysupgrade.url).body
    self.latest_version_data = JSON.parse(body).with_indifferent_access
  rescue Faraday::ConnectionFailed
    self.latest_version_data = nil
  end
end
