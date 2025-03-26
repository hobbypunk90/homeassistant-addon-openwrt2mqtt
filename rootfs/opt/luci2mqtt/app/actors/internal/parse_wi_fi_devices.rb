# frozen_string_literal: true

class Internal::ParseWiFiDevices < Actor
  prepend WhosGonnaCallMe

  input :host_hints
  input :plain_text_devices
  input :wifi_network
  output :devices

  def call
    self.devices = plain_text_devices.map { |plain_text_network| parse_wifi_device(plain_text_network) }
  end

  private

  def parse_wifi_device(text)
    device = WiFiDevice.new
    device.mac_address = text[/^([A-F0-9:]+)/, 1]
    device.hostname = host_hints.fetch(device.mac_address, {})[:name]
    device.ipv4_address = host_hints.fetch(device.mac_address, {})[:ipv4]
    device.ipv6_address = host_hints.fetch(device.mac_address, {})[:ipv6]
    device.last_seen_ago = ActiveSupport::Duration.build(text[/([0-9]+) ms ago/, 1].to_i / 1000.0)
    device.wifi_network = wifi_network

    device
  end
end
