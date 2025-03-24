# frozen_string_literal: true

class Router < ApplicationModel
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

  def wifi_networks
    @wifi_networks ||= begin
                         result = GetWiFiNetworks.result(router: self)

                         result.networks if result.success?
                       end
  end

  def wifi_devices
    @wifi_devices ||= begin
                        wifi_networks.map(&:wifi_devices).flatten
                      end
  end

  def discovery

  end

  def identifier
    @identifier ||= Digest::SHA1.hexdigest(wifi_networks.map(&:access_point).sort.join(','))
  end
  def discovery_device
    {
      configuration_url: Settings.luci.url,
      identifiers: [identifier],
      manufacturer:,
      model:,
      model_id: board_name,
      name: hostname,
      sw_version: "#{os} #{os_version}"
    }
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
