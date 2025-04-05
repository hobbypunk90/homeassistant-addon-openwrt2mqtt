# frozen_string_literal: true

class Mqtt::Actor < ApplicationActor
  def client
    @@client = MQTT::Client.connect(
      host: Settings.mqtt.host,
      port: Settings.mqtt.port,
      ssl: Settings.mqtt.ssl,
      username: Settings.mqtt.username,
      password: Settings.mqtt.password,
    )
  end

  def retain
    Settings.mqtt.retain
  end

  def publish(topic, payload)
    client.publish(topic, payload, retain)
  end

  def get(topic)
    entries = []
    Timeout::timeout(0.5) do
      client.get(topic) do |topic,payload|
        entries << [topic, payload]
      end
    end
  rescue Timeout::Error
  ensure
    entries
  end
end
