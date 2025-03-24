# frozen_string_literal: true

class WiFiNetwork < ApplicationModel
  attribute :router
  attribute :device
  attribute :network_name
  attribute :access_point
  attribute :channel
  attribute :frequency
  attribute :ht_mode
  attribute :hw_modes

  def wifi_devices
    @wifi_devices ||= begin
                        result = GetWiFiDevices.result(wifi_network: self)
                        result.devices if result.success?
                      end
  end

  def to_s
    <<~MSG
      WiFiNetwork[#{device}]: <#{network_name}>
        #{access_point}, Channel: #{channel} (#{frequency} GHz), HT Mode: #{ht_mode}
        HW Modes: #{hw_modes}
    MSG
  end
end
