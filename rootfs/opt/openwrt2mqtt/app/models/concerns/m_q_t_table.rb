# frozen_string_literal: true

module MQTTable
  extend ActiveSupport::Concern
  included do
    mqtt_origin name: "OpenWRT 2 MQTT", sw_version: Settings.version,
                url: "https://github.com/hobbypunk90/homeassistant-addon-openwrt2mqtt"

    after_destroy :destroy_mqtt
  end

  class_methods do
    attr_accessor :_mqtt_origin, :_mqtt_device, :_mqtt_components

    def mqtt_origin(**attributes)
      self._mqtt_origin = attributes
    end

    def mqtt_device(**attributes)
      self._mqtt_device = attributes
    end

    def mqtt_attribute(attribute, type, value = attribute, **options)
      self._mqtt_components = {} unless _mqtt_components
      value = -> { send(attribute).iso8601 } if options[:device_class] == :timestamp && value == attribute

      _mqtt_components[attribute] = {
        name: attribute.to_s.humanize,
        value:,
        platform: type,
        if: -> { true },
        **options
      }
    end
  end

  delegate :_mqtt_origin, :_mqtt_device, :_mqtt_components, to: :class
  alias mqtt_origin _mqtt_origin
  alias mqtt_device _mqtt_device
  alias mqtt_components _mqtt_components


  def mqtt_id
    self.valid? if id.nil?

    @mqtt_id ||= "#{self.class.name.downcase}/#{id}"
  end

  def discoverable?
    true
  end

  def discovery_topic
    "#{Settings.mqtt.topics.discovery}/device/#{mqtt_id}/config"
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
    end.compact

    {
      origin: mqtt_origin,
      device: {
        **device,
        identifiers: mqtt_id
      },
      components: discovery_components
    }.compact
  end

  def discovery_components
    mqtt_components.filter { |_, config| instance_exec(&config[:if]) }.to_h do |attribute, config|
      unique_id = "#{mqtt_id}_#{attribute}"
      name = if config[:platform] == :device_tracker
               labels&.first { |label| label.start_with?("device_tracker.")&.gsub("device_tracker.", "") } ||
                 hostname
             end
      attributes = config[:attributes]
      [
        unique_id,
        config.filter { |key, _v| [:value, :attributes, :if].exclude?(key) }.merge({
          unique_id:,
          name:,
          state_topic: attribute_topic(attribute),
          value_template: ("{{ value_json.state }}" if attributes),
          json_attributes_topic: (attribute_topic(attribute) if attributes),
          json_attributes_template: ("{{ value_json.attributes }}" if attributes),
          source_type: (:router if config[:platform] == :device_tracker)
        }.compact)
      ]
    end
  end

  def attribute_topic(attribute)
    platform = mqtt_components[attribute][:platform]

    "#{Settings.mqtt.topics.base}/#{platform}/#{mqtt_id}/#{attribute}"
  end

  def attribute_value(attribute)
    value = mqtt_components[attribute][:value]
    attributes = mqtt_components[attribute][:attributes]

    value = if value.is_a? Symbol
              send(value)
            elsif value.is_a? Proc
              instance_exec(&value)
            else
              value
            end
    if mqtt_components[attribute][:platform] == :binary_sensor
      value = value ? "ON" : "OFF"
    end

    if attributes.nil?
      return value.to_json if value.is_a?(Hash) || value.is_a?(Array)
      return value
    end

    attributes = if attributes.is_a? Symbol
                   send(attributes)
                 elsif attributes.is_a? Proc
                   instance_exec(&attributes)
                 else
                   attributes
                 end

    { state: value, attributes: attributes.to_json }
  end

  def destroy_mqtt
    Mqtt::DeleteJob.perform_later(discovery_topic)

    mqtt_components.filter { |_, config| instance_exec(&config[:if]) }.each_key do |attribute|
      Mqtt::DeleteJob.perform_later(attribute_topic(attribute))
    end
  end
end
