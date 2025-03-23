# frozen_string_literal: true

class Internal::ParseSystemInfo < Actor
  input :system_info
  input :device

  def call
    device.localtime = Time.at(system_info[:localtime].to_i).to_datetime
    device.uptime = ActiveSupport::Duration.build(system_info[:uptime].to_i)
  end
end
