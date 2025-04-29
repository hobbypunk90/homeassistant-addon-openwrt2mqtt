# frozen_string_literal: true

class WiFiNetwork < ApplicationRecord
  include MQTTable

  belongs_to :router, touch: true
  has_many :wifi_devices, class_name: "WiFiDevice", dependent: :destroy

  mqtt_device configuration_url: Settings.openwrt.url,
              name: -> { "#{network_name} (#{frequency} GHz)" },
              manufacturer: :manufacturer,
              model: :model,
              model_id: :device,
              via_device: -> { router.mqtt_id },
              sw_version: -> { "#{os} #{os_version}" }
  mqtt_attribute :network_name, :sensor
  mqtt_attribute :device, :sensor
  mqtt_attribute :frequency, :sensor, device_class: :frequency, unit_of_measurement: :GHz
  mqtt_attribute :wifi_devices, :sensor, -> { wifi_devices.size }, state_class: :measurement
  mqtt_attribute :mac_address, :sensor, :access_point
  mqtt_attribute :channel, :sensor
  mqtt_attribute :ht_mode, :sensor
  mqtt_attribute :hw_modes, :sensor

  delegate :manufacturer, :model, :os, :os_version, to: :router

  before_validation do
    self.id = Digest::SHA1.hexdigest("#{device},#{network_name},#{access_point}")
  end

  def to_s
    <<~MSG
      WiFiNetwork[#{device}]: <#{network_name}>
        #{access_point}, Channel: #{channel} (#{frequency} GHz), HT Mode: #{ht_mode}
        HW Modes: #{hw_modes}
    MSG
  end
end

# ## Schema Information
#
# Table name: `wi_fi_networks`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `string`           | `not null, primary key`
# **`access_point`**  | `string`           |
# **`channel`**       | `integer`          |
# **`device`**        | `string`           |
# **`frequency`**     | `decimal(4, 3)`    |
# **`ht_mode`**       | `string`           |
# **`hw_modes`**      | `string`           |
# **`network_name`**  | `string`           |
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`router_id`**     | `string`           | `not null`
#
# ### Indexes
#
# * `index_wi_fi_networks_on_router_id`:
#     * **`router_id`**
#
# ### Foreign Keys
#
# * `router_id`:
#     * **`router_id => routers.id`**
#
