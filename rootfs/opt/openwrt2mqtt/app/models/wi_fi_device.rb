# frozen_string_literal: true

class WiFiDevice < ApplicationRecord
  include MQTTable

  belongs_to :wifi_network, class_name: "WiFiNetwork", foreign_key: :wi_fi_network_id
  has_one :router, through: :wifi_network

  mqtt_device configuration_url: Settings.openwrt.url,
              name: :hostname,
              manufacturer: -> { GetMacVendor.call(mac_address:).vendor_name },
              model_id: :mac_address,
              via_device: -> { wifi_network.mqtt_id }

  mqtt_attribute :mac_address, :sensor
  mqtt_attribute :ip_address, :sensor, -> { ipv4_address || ipv6_address }
  mqtt_attribute :last_seen_at, :sensor, device_class: :timestamp
  mqtt_attribute :label, :sensor, -> { labels&.first }, attributes: -> { { labels: } }

  validates :labels, presence: true, if: -> { labels.nil? }

  before_validation do
    self.id = Digest::SHA1.hexdigest(mac_address)
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
