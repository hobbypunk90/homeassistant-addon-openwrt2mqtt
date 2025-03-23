# frozen_string_literal: true

class Internal::ParseBoard < Actor
  input :board
  output :device

  def call
    self.device = device = Device.new
    device.kernel = board[:kernel]
    device.hostname = board[:hostname]
    device.system = board[:system]
    device.model = board[:model]
    device.board_name = board[:board_name]
    device.os = board[:release][:distribution]
    device.os_version = board[:release][:version]
    device.build_date = Time.at(board[:release][:builddate].to_i).to_datetime
  end
end
