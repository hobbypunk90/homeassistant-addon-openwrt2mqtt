# frozen_string_literal: true

class WiFiDevice < ApplicationModel
  include MQTTable

  attribute :wifi_network

  attribute :mac_address
  attribute :hostname
  attribute :ipv4_address
  attribute :ipv6_address
  attribute :last_seen_ago
  attribute :labels

  mqtt_device configuration_url: Settings.luci.url,
              name: :hostname,
              manufacturer: -> { GetMacVendor.call(mac_address:).vendor_name },
              model_id: :mac_address,
              via_device: -> { wifi_network.identifier }

  mqtt_attribute :mac_address, :sensor
  mqtt_attribute :ip_address, :sensor, -> { ipv4_address || ipv6_address }
  mqtt_attribute :last_seen_ago, :sensor, device_class: :duration, unit_of_measurement: :s
  mqtt_attribute :label, :sensor, -> { labels&.first }, attributes: -> { { labels: } }

  def wifi_network=(wifi_network)
    super
    wifi_network.add_wifi_device(self)
  end

  def identifier(_identifier = nil)
    super Digest::SHA1.hexdigest(mac_address)
  end

  def discoverable?
    hostname.present?
  end

  def to_s
    <<~MSG
      WiFiDevice[#{mac_address}]: <#{hostname}>
        #{ipv4_address}, #{ipv6_address}
        #{last_seen_ago.inspect}
    MSG
  end
end
