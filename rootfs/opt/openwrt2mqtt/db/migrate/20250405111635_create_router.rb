class CreateRouter < ActiveRecord::Migration[8.0]
  def change
    create_table :routers, id: :string do |t|
      t.string :kernel
      t.string :hostname
      t.string :system
      t.string :manufacturer
      t.string :model
      t.string :board_name
      t.string :os
      t.string :os_version
      t.datetime :build_date

      t.timestamps
    end
  end
end
