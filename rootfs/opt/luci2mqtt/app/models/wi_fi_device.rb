# frozen_string_literal: true

class WiFiDevice < ApplicationModel
  attribute :mac_address
  attribute :hostname
  attribute :ipv4_address
  attribute :ipv6_address

  attribute :last_seen_ago

  attribute :wifi_network

  def wifi_network=(wifi_network)
    super
    wifi_network.add_wifi_device(self)
  end

  def identifier
    @identifier ||= Digest::SHA1.hexdigest(mac_address)
  end

  def discovery_device
    {
      connections: [['mac', mac_address]],
      identifiers: identifier,
      hw_version: access_point,
      model: network_name,
      name: hostname,
      via_device: wifi_network.identifier
    }
  end

  def to_s
    <<~MSG
      WiFiDevice[#{mac_address}]: <#{hostname}>
        #{ipv4_address}, #{ipv6_address}
        #{last_seen_ago.inspect}
    MSG
  end
end
