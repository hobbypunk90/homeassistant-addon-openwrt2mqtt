class AddFieldsToRouter < ActiveRecord::Migration[8.0]
  def change
    change_table :routers do |t|
      t.timestamp :localtime
      t.integer :uptime

      t.decimal :load_last_min, precision: 4, scale: 2
      t.decimal :load_last_5min, precision: 4, scale: 2
      t.decimal :load_last_15min, precision: 4, scale: 2

      t.integer :memory_total
      t.integer :memory_available
      t.integer :memory_shared
      t.integer :memory_buffered
      t.integer :memory_cached

      t.integer :fs_root_total
      t.integer :fs_root_free
      t.integer :fs_root_used
    end
  end
end
