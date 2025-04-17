# frozen_string_literal: true

class Internal::ParseBoard < ApplicationActor
  prepend WhosGonnaCallMe

  input :board
  input :router

  def call
    router.kernel = board[:kernel]
    router.hostname = board[:hostname]
    router.system = board[:system]
    router.manufacturer = board[:model].split(" ").first
    router.model = board[:model].split(" ").last
    router.board_name = board[:board_name]
    router.os = board[:release][:distribution]
    router.os_version = board[:release][:version]
    router.build_date = Time.at(board[:release][:builddate].to_i).to_datetime
    router.save!
  end
end
