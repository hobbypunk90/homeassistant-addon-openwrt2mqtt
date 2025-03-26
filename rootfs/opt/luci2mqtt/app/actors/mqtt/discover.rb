# frozen_string_literal: true

class Mqtt::Discover < Mqtt::Actor
  input :object, type: MQTTable

  def call
    publish(object.discovery_topic, object.discovery.to_json)
  end
end
