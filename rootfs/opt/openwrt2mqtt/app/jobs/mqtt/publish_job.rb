class Mqtt::PublishJob < ApplicationJob
  queue_as :'mqtt/publish'

  def perform(topic, payload)
    payload = payload.to_json if payload.is_a?(Hash) || payload.is_a?(Array)

    HomeAssistantMqttPool.with { |connection| connection.publish(topic, payload, retain) }
  end

  private

  def retain
    Settings.mqtt.retain
  end
end
