# frozen_string_literal: true

class Mqtt::Publish < Mqtt::Actor
  input :object, type: MQTTable

  def call
    object.mqtt_components.each_key do |attribute|
      publish(object.attribute_topic(attribute), object.attribute_value(attribute))
    end
  end
end
