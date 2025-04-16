# frozen_string_literal: true

class Internal::ParseSystemInfo < ApplicationActor
  prepend WhosGonnaCallMe

  input :system_info
  input :router

  def call
    router.localtime = Time.at(system_info[:localtime].to_i).to_datetime
    router.uptime = ActiveSupport::Duration.build(system_info[:uptime].to_i)

    router.load_last_min = system_info[:load][0] / 1000.0
    router.load_last_5min = system_info[:load][1] / 1000.0
    router.load_last_15min = system_info[:load][2] / 1000.0

    router.memory_total = system_info[:memory][:total]
    router.memory_available = system_info[:memory][:available]
    router.memory_shared = system_info[:memory][:shared]
    router.memory_buffered = system_info[:memory][:buffered]
    router.memory_cached = system_info[:memory][:cached]

    router.fs_root_total = system_info[:root][:total]
    router.fs_root_free = system_info[:root][:free]
    router.fs_root_used = system_info[:root][:used]
    router.save!
  end
end
