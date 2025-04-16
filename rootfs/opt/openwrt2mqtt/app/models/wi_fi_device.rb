# frozen_string_literal: true

class WiFiDevice < ApplicationRecord
  include MQTTable

  belongs_to :wifi_network, class_name: "WiFiNetwork", foreign_key: :wi_fi_network_id, touch: true
  has_one :router, through: :wifi_network

  mqtt_device configuration_url: Settings.openwrt.url,
              name: :hostname,
              manufacturer: -> { GetMacVendor.call(mac_address:).vendor_name },
              model_id: :mac_address,
              via_device: -> { wifi_network.mqtt_id }

  mqtt_attribute :mac_address, :sensor, entity_category: :diagnostic
  mqtt_attribute :ip_address, :sensor, -> { ipv4_address || ipv6_address }, entity_category: :diagnostic
  mqtt_attribute :last_seen_at, :sensor, device_class: :timestamp, entity_category: :diagnostic
  mqtt_attribute :label, :sensor, -> { labels&.first }, attributes: -> { { labels: } }, entity_category: :diagnostic
  mqtt_attribute :online, :binary_sensor, -> { online? }, device_class: :connectivity
  mqtt_attribute :state, :device_tracker, -> { online? ? :home : :not_home },
                 attributes: -> { {
                   mac_address:,
                   ip_address: ipv4_address || ipv6_address,
                   hostname:,
                   latitude: Settings.openwrt.latitude,
                   longitude: Settings.openwrt.longitude,
                   gps_accuracy: (0.0 if Settings.openwrt.latitude)
                 }.compact },
                 if: -> { labels&.any? { |label| label.start_with?("device_tracker") } }
  validates :labels, presence: true, if: -> { labels.nil? }

  before_validation do
    self.id = Digest::SHA1.hexdigest(mac_address)
  end

  def online?
    last_seen_at > 2.5.minutes.ago
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

# ## Schema Information
# Schema version: 20250416131910
#
# Table name: `wi_fi_devices`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `string`           | `not null, primary key`
# **`hostname`**          | `string`           |
# **`ipv4_address`**      | `string`           |
# **`ipv6_address`**      | `string`           |
# **`labels`**            | `json`             | `not null`
# **`last_seen_at`**      | `datetime`         |
# **`mac_address`**       | `string`           |
# **`created_at`**        | `datetime`         | `not null`
# **`updated_at`**        | `datetime`         | `not null`
# **`wi_fi_network_id`**  | `string`           | `not null`
#
# ### Indexes
#
# * `index_wi_fi_devices_on_wi_fi_network_id`:
#     * **`wi_fi_network_id`**
#
# ### Foreign Keys
#
# * `wi_fi_network_id`:
#     * **`wi_fi_network_id => wi_fi_networks.id`**
#
# ### Check Constraints
#
# * `labels_is_array`: `(JSON_TYPE(labels) = 'array')`
#
