# frozen_string_literal: true

class Luci::Actor < ApplicationActor
  def get(path, options)
    connection.get("/#{path}", options)
  end

  def post(path, method:, params: [])
    path = "#{path}?auth=#{auth_token}" if auth_token

    response = connection.post("/#{path}", { id:, method:, params: }.to_json)
    response = JSON.parse(response.body).with_indifferent_access
    return response[:result] if response[:error].nil?

    raise NoMethodError if response[:error][:message] == "Method not found."
    raise StandardError, response[:error][:message]
  end

  def ubus(method, params = [])
    ubus_session = self.ubus_session ? self.ubus_session : '00000000000000000000000000000000'

    response = connection.post('/ubus', { id: 1, jsonrpc: '2.0', method:, params: [ubus_session] + params }.to_json)
    response = JSON.parse(response.body).with_indifferent_access
  end

  private

  def id
    @id ||= SecureRandom.uuid
  end

  def connection
    @connection ||= Faraday.new(Settings.openwrt.url) do |faraday|
      faraday.response :logger if Settings.debug
    end
  end
end
