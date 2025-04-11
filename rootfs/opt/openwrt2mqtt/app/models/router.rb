# frozen_string_literal: true

class Router < ApplicationRecord
  include MQTTable

  has_many :wifi_networks, class_name: "WiFiNetwork"
  has_many :wifi_devices, class_name: "WiFiDevice", through: :wifi_networks

  attribute :localtime
  attribute :uptime

  mqtt_device configuration_url: Settings.openwrt.url,
              manufacturer: :manufacturer,
              model: :model,
              model_id: :board_name,
              name: :hostname,
              sw_version: -> { "#{os} #{os_version}" }
  mqtt_attribute :uptime, :sensor, device_class: :duration, unit_of_measurement: :s
  mqtt_attribute :wifi_networks, :sensor, -> { wifi_networks.size }
  mqtt_attribute :wifi_devices, :sensor, -> { wifi_devices.size }

  before_validation do
    self.id = Digest::SHA1.hexdigest("#{Settings.openwrt.url},#{Settings.openwrt.username}")
  end

  def to_s
    <<~MSG
      Device[#{hostname}]: <#{model}>
        System: #{system}, Kernel: #{kernel}
        OS: #{os} Version: #{os_version}
        Build date: #{build_date}

        Localtime: #{localtime}, Uptime: #{uptime.inspect}
    MSG
  end
end

# ## Schema Information
#
# Table name: `routers`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `string`           | `not null, primary key`
# **`board_name`**    | `string`           |
# **`build_date`**    | `datetime`         |
# **`hostname`**      | `string`           |
# **`kernel`**        | `string`           |
# **`manufacturer`**  | `string`           |
# **`model`**         | `string`           |
# **`os`**            | `string`           |
# **`os_version`**    | `string`           |
# **`system`**        | `string`           |
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
#
