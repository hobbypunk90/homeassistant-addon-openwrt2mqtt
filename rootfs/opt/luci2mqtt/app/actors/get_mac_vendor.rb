# frozen_string_literal: true

class GetMacVendor < Actor
  input :mac_address
  output :vendor_name

  def call
    vendor_id = mac_address.split(/[:-]/)[0..2].join('')

    line = File.foreach('./vendors/mac_vendors.csv').grep(/#{vendor_id}/)[0]
    return if line.nil?
    self.vendor_name = line.split(',')[2].gsub('"', '')
  end
end
