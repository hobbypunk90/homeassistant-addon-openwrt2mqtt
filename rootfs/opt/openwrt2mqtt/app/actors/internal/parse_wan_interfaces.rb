# frozen_string_literal: true

class Internal::ParseWanInterfaces < ApplicationActor
  prepend WhosGonnaCallMe

  input :wan_interfaces
  input :router

  def call
    return if wan_interfaces.nil?

    router.wan_interfaces = {}

    wan_interfaces.each do |interface, status|
      router.wan_interfaces[interface] = {
        enabled: status[:enabled],
        running: status[:running],
        up: status[:up],
        status: status[:status],
        tracking: status[:tracking],
        online_since: status[:online],
        offline_since: status[:offline],
        public_ip: status[:public_ip]
      }
    end

    router.save!
  end
end
