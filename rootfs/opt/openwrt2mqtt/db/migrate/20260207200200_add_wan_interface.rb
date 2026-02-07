class AddWanInterface < ActiveRecord::Migration[8.0]
  def change
    remove_column :routers, :wan_online, :boolean
    remove_column :routers, :wan_ipv4_address, :string

    add_column :routers, :wan_interfaces, :jsonb
  end
end
