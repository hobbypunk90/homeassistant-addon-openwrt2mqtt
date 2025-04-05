class CreateWiFiDevice < ActiveRecord::Migration[8.0]
  def change
    create_table :wi_fi_devices, id: :string do |t|
      t.belongs_to :wi_fi_network, type: :string, null: false, foreign_key: true
      t.string :mac_address
      t.string :hostname
      t.string :ipv4_address
      t.string :ipv6_address
      t.json :labels, null: false, default: []
      t.check_constraint "JSON_TYPE(labels) = 'array'", name: 'labels_is_array'

      t.timestamp :last_seen_at
      t.timestamps
    end
  end
end
