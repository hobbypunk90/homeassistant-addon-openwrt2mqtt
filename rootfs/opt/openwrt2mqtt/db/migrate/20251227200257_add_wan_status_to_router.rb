class AddWanStatusToRouter < ActiveRecord::Migration[8.0]
  def change
    add_column :routers, :wan_online, :boolean
    add_column :routers, :wan_ipv4_address, :string

  end
end
