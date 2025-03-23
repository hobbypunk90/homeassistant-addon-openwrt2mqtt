# frozen_string_literal: true

class Device < ApplicationModel
  attribute :kernel
  attribute :hostname
  attribute :system
  attribute :model
  attribute :board_name
  attribute :os
  attribute :os_version
  attribute :build_date

  attribute :localtime
  attribute :uptime

  def wifi_networks
    @wifi_networks ||= begin
                         result = GetWiFiNetworks.result

                         result.networks if result.success?
                       end
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
