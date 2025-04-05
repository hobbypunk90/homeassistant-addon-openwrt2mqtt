# frozen_string_literal: true

class Internal::ParseWiFiNetworks < ApplicationActor
  prepend WhosGonnaCallMe

  input :router
  input :plain_text_networks
  output :networks

  def call
    self.networks = plain_text_networks.map { |plain_text_network| parse_wifi_network(plain_text_network) }
  end

  private

  def parse_wifi_network(text)
    wifi = WiFiNetwork.find_or_initialize_by(device: text[/^([a-z0-9\-]+)/, 1],
                                             network_name: text[/ESSID: "(.+)"$/, 1],
                                             access_point: text[/Access Point: ([0-9A-F:]+)/, 1])
    wifi.channel = (text[/Channel: ([0-9]+) \(([0-9.]+) GHz\)\s+HT Mode: ([A-Z0-9]+)/, 1]).to_i
    wifi.frequency = (text[/Channel: ([0-9]+) \(([0-9.]+) GHz\)\s+HT Mode: ([A-Z0-9]+)/, 2]).to_f
    wifi.ht_mode = text[/Channel: ([0-9]+) \(([0-9.]+) GHz\)\s+HT Mode: ([A-Z0-9]+)/, 3]
    wifi.hw_modes = text[/HW Mode\(s\): ([\S]+)/, 1]
    wifi.router = router
    wifi.save!

    wifi
  end
end
