class Mqtt::PublishAllJob < ApplicationJob
  queue_as :'mqtt/publish_all'

  def perform(*args)
    Router.all.each do |router|
      publish(router)
      router.wifi_networks.filter(&:discoverable?).each do |wifi_network|
        publish(wifi_network)
      end

      router.wifi_devices.filter(&:discoverable?).each do |wifi_device|
        publish(wifi_device)
      end
    end
  end

  private

  def publish(object)
    object.mqtt_components.each do |attribute, config|
      next unless object.instance_exec(&config[:if])

      Mqtt::PublishJob.perform_later(object.attribute_topic(attribute), object.attribute_value(attribute))
    end
  end
end
