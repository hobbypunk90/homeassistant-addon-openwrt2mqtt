# frozen_string_literal: true

class Router < ApplicationModel
  include MQTTable

  attribute :kernel
  attribute :hostname
  attribute :system
  attribute :manufacturer
  attribute :model
  attribute :board_name
  attribute :os
  attribute :os_version
  attribute :build_date

  attribute :localtime
  attribute :uptime

  mqtt_device configuration_url: Settings.luci.url,
              manufacturer: :manufacturer,
              model: :model,
              model_id: :board_name,
              name: :hostname,
              sw_version: -> { "#{os} #{os_version}" }
  mqtt_attribute :uptime, :sensor, device_class: :duration, unit_of_measurement: :s
  mqtt_attribute :wifi_networks, :sensor, -> { wifi_networks.size }

  def wifi_networks
    @wifi_networks.values
  end

  def add_wifi_network(network)
    (@wifi_networks ||= {})[network.identifier] = network
  end

  def wifi_devices
    @wifi_devices.values
  end

  def add_wifi_device(device)
    (@wifi_devices ||= {})[device.identifier] = device
  end


  def identifier(_identifier = nil)
    super Digest::SHA1.hexdigest(wifi_networks.map(&:identifier).sort.join(','))
  end

  def discover_all
    discover
    wifi_networks.each(&:discover_all)
  end

  def publish_all
    publish
    wifi_networks.each(&:publish_all)
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
