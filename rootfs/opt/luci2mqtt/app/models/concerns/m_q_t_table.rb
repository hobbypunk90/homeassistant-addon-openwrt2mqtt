# frozen_string_literal: true

module MQTTable

  def self.included(base)
    # base is our target class. Invoke `extend` on it and pass nested module with class methods.
    base.extend ClassMethods

    base.mqtt_origin name: 'OpenWRT2mqtt',
                     sw_version: 'dev',
                     url: 'https://github.com/hobbypunk90/homeassistant-addon-luci2mqtt'
  end

  module ClassMethods
    attr_accessor :_mqtt_origin, :_mqtt_device, :_mqtt_components

    def mqtt_origin(**attributes)
      self._mqtt_origin = attributes
    end

    def mqtt_device(**attributes)
      self._mqtt_device = attributes
    end

    def mqtt_attribute(attribute, type, value = attribute, **options)
      self._mqtt_components = {} unless _mqtt_components

      _mqtt_components[attribute] = {
        name: attribute.to_s.humanize,
        value:,
        platform: type,
        **options
      }
    end
  end
  delegate :_mqtt_origin, :_mqtt_device, :_mqtt_components, to: :class
  alias mqtt_origin _mqtt_origin
  alias mqtt_device _mqtt_device
  alias mqtt_components _mqtt_components

  def identifier(identifier)
    @identifier ||= "#{self.class.name.downcase}/#{identifier}"
  end

  def discoverable?
    true
  end

  def discover
    Mqtt::Discover.call(object: self)
  end

  def publish
    Mqtt::Publish.call(object: self)
  end

  def discovery_topic
    "#{Settings.mqtt.topics.discovery}/device/#{identifier(nil)}/config"
  end

  def discovery
    device = mqtt_device.transform_values do |value|
      if value.is_a? Symbol
        send(value)
      elsif value.is_a? Proc
        instance_exec(&value)
      else
        value
      end
    end

    {
      origin: mqtt_origin,
      device: {
        **device,
        identifiers: identifier(nil)
      },
      components: discovery_components
    }.compact
  end

  def discovery_components
    mqtt_components.to_h do |attribute, config|
      unique_id = "#{identifier(nil)}_#{attribute}"
      [
        unique_id,
        config.filter { |key,_v| key != :value }.merge({
          unique_id:,
          state_topic: attribute_topic(attribute)
        })
      ]
    end
  end

  def attribute_topic(attribute)
    plattform = mqtt_components[attribute][:plattform]

    "#{Settings.mqtt.topics.base}/#{plattform}/#{identifier(nil)}/#{attribute}"
  end

  def attribute_value(attribute)
    value = mqtt_components[attribute][:value]

    value = if value.is_a? Symbol
              send(value)
            elsif value.is_a? Proc
              instance_exec(&value)
            else
              value
            end
    return value.to_json if value.is_a?(Hash) || value.is_a?(Array)

    value
  end
end
