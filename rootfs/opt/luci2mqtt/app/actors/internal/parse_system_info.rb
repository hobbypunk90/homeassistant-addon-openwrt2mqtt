# frozen_string_literal: true

class Internal::ParseSystemInfo < Actor
  input :system_info
  input :router

  def call
    router.localtime = Time.at(system_info[:localtime].to_i).to_datetime
    router.uptime = ActiveSupport::Duration.build(system_info[:uptime].to_i)
  end
end
