# frozen_string_literal: true

class WiFiDevice < ApplicationModel
  attribute :mac_address
  attribute :hostname
  attribute :ipv4_address
  attribute :ipv6_address

  attribute :last_seen_ago

  attribute :wifi_network

  def to_s
    <<~MSG
      WiFiDevice[#{mac_address}]: <#{hostname}>
        #{ipv4_address}, #{ipv6_address}
        #{last_seen_ago.inspect}
    MSG
  end
end
