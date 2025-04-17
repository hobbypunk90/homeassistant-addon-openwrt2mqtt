# frozen_string_literal: true

class Internal::ParseLatestVersionData < ApplicationActor
  prepend WhosGonnaCallMe

  input :latest_version_data
  input :router

  def call
    router.os_version_latest = latest_version_data[:latest].first
    router.save!
  end
end
