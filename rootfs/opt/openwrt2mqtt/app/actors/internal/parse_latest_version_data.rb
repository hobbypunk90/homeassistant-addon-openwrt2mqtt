# frozen_string_literal: true

class Internal::ParseLatestVersionData < ApplicationActor
  prepend WhosGonnaCallMe

  input :latest_version_data
  input :router

  def call
    router.os_version_latest = latest_version_data[:latest].first if latest_version_data.present?
    router.save!
  end
end
