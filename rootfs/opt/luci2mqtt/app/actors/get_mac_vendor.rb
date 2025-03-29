# frozen_string_literal: true

class GetMacVendor < Actor
  input :mac_address
  output :vendor_name

  def call
    vendor_id = mac_address.split(/[:-]/)[0..3].join(':')

    vendors = get(vendor_id)
    return if vendors.nil?

    self.vendor_name = vendors.first[:company]
  end

  private

  def connection
    @connection ||= Faraday.new(Settings.mac_resolver.url)do |faraday|
      faraday.response :logger if Settings.debug
    end
  end

  def get(mac_address, options = {})
    response = connection.get("/api/v2/#{mac_address}", options)
    return if response.body.empty?

    JSON.parse(response.body).map(&:with_indifferent_access)
  end
end
