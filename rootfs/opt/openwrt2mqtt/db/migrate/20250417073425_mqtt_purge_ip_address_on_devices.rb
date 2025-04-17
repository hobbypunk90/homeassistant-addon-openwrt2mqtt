class MqttPurgeIpAddressOnDevices < ActiveRecord::Migration[8.0]
  def up
    WiFiDevice.all.each do |device|
      Mqtt::PublishJob.perform_later("#{Settings.mqtt.topics.base}/sensor/#{device.mqtt_id}/ip_address", nil)
    end
    Mqtt::DiscoverAllJob.perform_later
  end

  def down; end
end
