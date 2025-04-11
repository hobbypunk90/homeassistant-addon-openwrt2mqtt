class Mqtt::DiscoverAllJob < ApplicationJob
  queue_as :'mqtt/discover_all'

  def perform(*args)
    Router.all.each do |router|
      send_discovery(router)
      router.wifi_networks.filter(&:discoverable?).each do |wifi_network|
        send_discovery(wifi_network)
      end

      router.wifi_devices.filter(&:discoverable?).each do |wifi_device|
        send_discovery(wifi_device)
      end
    end
  end

  private

  def send_discovery(object)
    Mqtt::PublishJob.perform_later(object.discovery_topic, object.discovery)
  end
end
