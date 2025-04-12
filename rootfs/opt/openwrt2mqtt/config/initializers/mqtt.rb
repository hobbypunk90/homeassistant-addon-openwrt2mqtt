
class MQTTClientWrapper
  attr_reader :client

  def initialize
    @client = MQTT::Client.new
    client.host = Settings.mqtt.host
    client.port = Settings.mqtt.port
    client.ssl  = Settings.mqtt.ssl
    client.username = Settings.mqtt.username
    client.password = Settings.mqtt.password

    client.connect
  end

  private

  def respond_to_missing?(name, include_private = false)
    client.respond_to?(name, include_private)
  end

  def method_missing(method, *args, &block)
    client.send(method, *args, &block)
  rescue MQTT::NotConnectedException
    client.connect
    client.send(method, *args, &block)
  end
end

HomeAssistantMqttPool = ConnectionPool.new(size: ENV.fetch("JOB_CONCURRENCY", 1) * 3, timeout: 5) { MQTTClientWrapper.new }
HomeAssistantMqttPool.shutdown { |connection| connection.disconnect }
