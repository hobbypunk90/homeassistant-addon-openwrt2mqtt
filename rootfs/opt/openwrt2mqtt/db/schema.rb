# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_17_075656) do
  create_table "routers", id: :string, force: :cascade do |t|
    t.string "kernel"
    t.string "hostname"
    t.string "system"
    t.string "manufacturer"
    t.string "model"
    t.string "board_name"
    t.string "os"
    t.string "os_version"
    t.datetime "build_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "localtime"
    t.integer "uptime"
    t.decimal "load_last_min", precision: 4, scale: 2
    t.decimal "load_last_5min", precision: 4, scale: 2
    t.decimal "load_last_15min", precision: 4, scale: 2
    t.integer "memory_total"
    t.integer "memory_available"
    t.integer "memory_shared"
    t.integer "memory_buffered"
    t.integer "memory_cached"
    t.integer "fs_root_total"
    t.integer "fs_root_free"
    t.integer "fs_root_used"
    t.string "os_version_latest"
  end

  create_table "wi_fi_devices", id: :string, force: :cascade do |t|
    t.string "wi_fi_network_id", null: false
    t.string "mac_address"
    t.string "hostname"
    t.string "ipv4_address"
    t.string "ipv6_address"
    t.json "labels", default: [], null: false
    t.datetime "last_seen_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wi_fi_network_id"], name: "index_wi_fi_devices_on_wi_fi_network_id"
    t.check_constraint "JSON_TYPE(labels) = 'array'", name: "labels_is_array"
  end

  create_table "wi_fi_networks", id: :string, force: :cascade do |t|
    t.string "router_id", null: false
    t.string "device"
    t.string "network_name"
    t.string "access_point"
    t.integer "channel"
    t.decimal "frequency", precision: 4, scale: 3
    t.string "ht_mode"
    t.string "hw_modes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["router_id"], name: "index_wi_fi_networks_on_router_id"
  end

  add_foreign_key "wi_fi_devices", "wi_fi_networks"
  add_foreign_key "wi_fi_networks", "routers"
end
