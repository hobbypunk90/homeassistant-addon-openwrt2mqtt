HomeAssistantMqttClient = MQTT::Client.connect(
                            host: Settings.mqtt.host, port: Settings.mqtt.port, ssl: Settings.mqtt.ssl,
                            username: Settings.mqtt.username, password: Settings.mqtt.password,
                          )
