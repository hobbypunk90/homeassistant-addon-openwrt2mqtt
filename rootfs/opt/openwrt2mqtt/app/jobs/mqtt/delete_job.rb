class Mqtt::DeleteJob < ApplicationJob
  queue_as :'mqtt/delete'

  def perform(topic)
    HomeAssistantMqttPool.with { |connection| connection.publish(topic, "", retain) }
  end

  private

  def retain
    Settings.mqtt.retain
  end
end
