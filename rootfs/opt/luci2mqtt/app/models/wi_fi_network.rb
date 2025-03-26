# frozen_string_literal: true

class WiFiNetwork < ApplicationModel
  include MQTTable

  attribute :router
  attribute :device
  attribute :network_name
  attribute :access_point
  attribute :channel
  attribute :frequency
  attribute :ht_mode
  attribute :hw_modes

  mqtt_device configuration_url: Settings.luci.url,
              name: -> { "#{network_name} (#{frequency} GHz)" },
              manufacturer: :manufacturer,
              model: :model,
              model_id: :device,
              via_device: -> { :identifier },
              sw_version: -> { "#{os} #{os_version}" }
  mqtt_attribute :wifi_devices, :sensor, -> { wifi_devices.size }
  mqtt_attribute :mac_address, :sensor, :access_point
  mqtt_attribute :channel, :sensor
  mqtt_attribute :ht_mode, :sensor
  mqtt_attribute :hw_modes, :sensor

  delegate :manufacturer, :model, :os, :os_version, to: :router

  def router=(router)
    super
    router.add_wifi_network(self)
  end

  def wifi_devices
    @wifi_devices&.values || []
  end

  def add_wifi_device(device)
    (@wifi_devices ||= {})[device.identifier] = device
    router.add_wifi_device(device)
  end

  def identifier(_identifier = nil)
    super Digest::SHA1.hexdigest("#{device},#{network_name},#{access_point}")
  end

  def discover_all
    discover
    #wifi_devices.each(&:discover)
  end

  def publish_all
    publish
    #wifi_devices.each(&:publish)
  end

  def to_s
    <<~MSG
      WiFiNetwork[#{device}]: <#{network_name}>
        #{access_point}, Channel: #{channel} (#{frequency} GHz), HT Mode: #{ht_mode}
        HW Modes: #{hw_modes}
    MSG
  end
end
