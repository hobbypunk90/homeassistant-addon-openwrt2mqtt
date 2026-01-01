# frozen_string_literal: true

class Internal::ParseWanStatus < ApplicationActor
  prepend WhosGonnaCallMe

  input :wan_status
  input :router

  def call
    router.wan_online = wan_status[:inet] == 0
    router.wan_ipv4_address = router.wan_online? ? wan_status[:mod_public_ip] : nil

    router.save!
  end
end
