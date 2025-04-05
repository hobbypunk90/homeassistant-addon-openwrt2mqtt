class CreateWiFiNetwork < ActiveRecord::Migration[8.0]
  def change
    create_table :wi_fi_networks, id: :string do |t|
      t.belongs_to :router, type: :string, null: false, foreign_key: true
      t.string :device
      t.string :network_name
      t.string :access_point
      t.integer :channel
      t.decimal :frequency, precision: 4, scale: 3
      t.string :ht_mode
      t.string :hw_modes

      t.timestamps
    end
  end
end
