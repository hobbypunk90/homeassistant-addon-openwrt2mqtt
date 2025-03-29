# frozen_string_literal: true

class Internal::ParseWiFiDevices < ApplicationActor
  prepend WhosGonnaCallMe

  input :host_hints
  input :dhcp_static_leases
  input :plain_text_devices
  input :wifi_network
  output :devices

  def call
    self.devices = plain_text_devices.map { |plain_text_network| parse_wifi_device(plain_text_network) }
  end

  private

  def parse_wifi_device(text)
    mac_address = text[/^([A-F0-9:]+)/, 1]
    dhcp_static_lease = dhcp_static_leases
                          .filter { |entry| entry[:mac].include? mac_address }
                          &.first || {}

    device = WiFiDevice.new
    device.mac_address = mac_address
    device.hostname = host_hints.fetch(device.mac_address, {})[:name] || dhcp_static_lease[:name]
    device.ipv4_address = host_hints.fetch(device.mac_address, {})[:ipv4]
    device.ipv6_address = host_hints.fetch(device.mac_address, {})[:ipv6]
    device.labels = dhcp_static_lease[:tag]
    device.last_seen_ago = ActiveSupport::Duration.build(text[/([0-9]+) ms ago/, 1].to_i / 1000.0)
    device.wifi_network = wifi_network

    device
  end
end
