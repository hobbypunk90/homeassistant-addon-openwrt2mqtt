class AddOsVersionLatestToRouter < ActiveRecord::Migration[8.0]
  def change
    add_column :routers, :os_version_latest, :string
  end
end
