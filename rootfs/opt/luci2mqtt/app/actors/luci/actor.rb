# frozen_string_literal: true

class Luci::Actor < Actor
  def get(path, options)
    connection.get("/#{path}", options)
  end

  def post(path, method:, params:)
    path = "#{path}?auth=#{auth_token}" if auth_token

    response = connection.post("/#{path}", { id:, method:, params: }.to_json)
    response = JSON.parse(response.body).with_indifferent_access
    return response[:result] if response[:error].nil?

    raise NoMethodError if response[:error][:message] == 'Method not found.'
    raise StandardError, response[:error][:message]
  end

  private

  def id
    @id ||= SecureRandom.uuid
  end

  def connection
    @connection ||= Faraday.new(Settings.luci.url)
  end
  def logger
    @logger ||= Logger.new($stdout)
  end
end
