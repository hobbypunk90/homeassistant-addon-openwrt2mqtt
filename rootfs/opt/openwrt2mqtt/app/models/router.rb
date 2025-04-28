# frozen_string_literal: true

class Router < ApplicationRecord
  include MQTTable

  has_many :wifi_networks, class_name: "WiFiNetwork", dependent: :destroy
  has_many :wifi_devices, class_name: "WiFiDevice", through: :wifi_networks

  mqtt_device configuration_url: Settings.openwrt.url,
              manufacturer: :manufacturer,
              model: :model,
              model_id: :board_name,
              name: :hostname,
              sw_version: -> { "#{os} #{os_version}" }

  mqtt_attribute :update, :update, lambda {
    release_url = if Settings.openwrt.sysupgrade.attended
                    "#{Settings.openwrt.url}/cgi-bin/luci/admin/system/attendedsysupgrade"
                  else
                    major, minor, bugfix = Gem::Version.new(os_version_latest).canonical_segments
                    "https://openwrt.org/releases/#{major}.#{minor}/notes-#{major}.#{minor}.#{bugfix}"
                  end
    {
      installed_version: os_version,
      latest_version: os_version_latest,
      release_url:
    }
  }, entity_picture: "#{Settings.openwrt.url}/luci-static/bootstrap/logo.svg"
  mqtt_attribute :wifi_networks, :sensor, -> { wifi_networks.size }, state_class: :measurement
  mqtt_attribute :wifi_devices, :sensor, -> { wifi_devices.size }, state_class: :measurement

  mqtt_attribute :uptime, :sensor, device_class: :duration, unit_of_measurement: :s, entity_category: :diagnostic

  mqtt_attribute :load_last_min, :sensor, state_class: :measurement, entity_category: :diagnostic
  mqtt_attribute :load_last_5min, :sensor, state_class: :measurement, entity_category: :diagnostic
  mqtt_attribute :load_last_15min, :sensor, state_class: :measurement, entity_category: :diagnostic

  mqtt_attribute :memory_total, :sensor, device_class: :data_size, unit_of_measurement: :B, entity_category: :diagnostic
  mqtt_attribute :memory_available, :sensor, device_class: :data_size, unit_of_measurement: :B, entity_category: :diagnostic
  mqtt_attribute :memory_shared, :sensor, device_class: :data_size, unit_of_measurement: :B, entity_category: :diagnostic
  mqtt_attribute :memory_buffered, :sensor, device_class: :data_size, unit_of_measurement: :B, entity_category: :diagnostic
  mqtt_attribute :memory_cached, :sensor, device_class: :data_size, unit_of_measurement: :B, entity_category: :diagnostic

  mqtt_attribute :fs_root_total, :sensor, device_class: :data_size, unit_of_measurement: :kB, entity_category: :diagnostic
  mqtt_attribute :fs_root_free, :sensor, device_class: :data_size, unit_of_measurement: :kB, entity_category: :diagnostic
  mqtt_attribute :fs_root_used, :sensor, device_class: :data_size, unit_of_measurement: :kB, entity_category: :diagnostic

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
# Schema version: 20250417075656
#
# Table name: `routers`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `string`           | `not null, primary key`
# **`board_name`**         | `string`           |
# **`build_date`**         | `datetime`         |
# **`fs_root_free`**       | `integer`          |
# **`fs_root_total`**      | `integer`          |
# **`fs_root_used`**       | `integer`          |
# **`hostname`**           | `string`           |
# **`kernel`**             | `string`           |
# **`load_last_15min`**    | `decimal(4, 2)`    |
# **`load_last_5min`**     | `decimal(4, 2)`    |
# **`load_last_min`**      | `decimal(4, 2)`    |
# **`localtime`**          | `datetime`         |
# **`manufacturer`**       | `string`           |
# **`memory_available`**   | `integer`          |
# **`memory_buffered`**    | `integer`          |
# **`memory_cached`**      | `integer`          |
# **`memory_shared`**      | `integer`          |
# **`memory_total`**       | `integer`          |
# **`model`**              | `string`           |
# **`os`**                 | `string`           |
# **`os_version`**         | `string`           |
# **`os_version_latest`**  | `string`           |
# **`system`**             | `string`           |
# **`uptime`**             | `integer`          |
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
#
