class Mqtt::PublishJob < ApplicationJob
  queue_as :mqtt

  def perform(topic, payload)
    payload = payload.to_json if payload.is_a?(Hash) || payload.is_a?(Array)

    client.publish(topic, payload, retain)
  end

  private

  def client
    HomeAssistantMqttClient
  end

  def retain
    Settings.mqtt.retain
  end
end
