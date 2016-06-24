# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160624192943) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "combo_algs", force: :cascade do |t|
    t.integer "alg1_id",         limit: 2
    t.integer "alg2_id",         limit: 2
    t.integer "combined_alg_id"
    t.integer "encoded_data",    limit: 2
  end

  add_index "combo_algs", ["combined_alg_id"], name: "index_combo_algs_on_combined_alg_id", using: :btree

  create_table "position_stats", force: :cascade do |t|
    t.integer "position_id"
    t.string  "marshaled_stats", limit: 255
  end

  add_index "position_stats", ["position_id"], name: "index_position_stats_on_position_id", using: :btree

  create_table "positions", force: :cascade do |t|
    t.string  "ll_code",            limit: 255
    t.integer "weight"
    t.integer "best_alg_id"
    t.string  "cop",                limit: 255
    t.string  "oll",                limit: 255
    t.string  "eo",                 limit: 255
    t.string  "ep",                 limit: 255
    t.integer "optimal_alg_length"
    t.string  "co",                 limit: 255
    t.string  "cp",                 limit: 255
    t.integer "mirror_id"
    t.integer "inverse_id"
    t.integer "main_position_id"
    t.integer "pov_offset"
  end

  add_index "positions", ["cop"], name: "index_positions_on_cop", using: :btree
  add_index "positions", ["eo"], name: "index_positions_on_eo", using: :btree
  add_index "positions", ["ep"], name: "index_positions_on_ep", using: :btree
  add_index "positions", ["ll_code"], name: "index_positions_on_ll_code", using: :btree
  add_index "positions", ["oll"], name: "index_positions_on_oll", using: :btree
  add_index "positions", ["optimal_alg_length", "cop", "eo", "ep"], name: "index_positions_on_optimal_alg_length_and_cop_and_eo_and_ep", using: :btree

  create_table "raw_algs", force: :cascade do |t|
    t.integer "length",      limit: 2
    t.integer "position_id", limit: 2
    t.integer "u_setup",     limit: 2
    t.string  "specialness", limit: 255
    t.integer "_speed",      limit: 2
    t.string  "_moves"
  end

  add_index "raw_algs", ["_speed", "length"], name: "index_raw_algs_on__speed_and_length", using: :btree
  add_index "raw_algs", ["length", "_speed"], name: "index_raw_algs_on_length_and__speed", using: :btree
  add_index "raw_algs", ["position_id", "_speed", "length"], name: "index_raw_algs_on_position_id_and__speed_and_length", using: :btree
  add_index "raw_algs", ["position_id", "length", "_speed"], name: "index_raw_algs_on_position_id_and_length_and__speed", using: :btree

  create_table "wca_user_data", force: :cascade do |t|
    t.integer "wca_db_id"
    t.string  "wca_id"
    t.string  "full_name"
  end

  add_index "wca_user_data", ["wca_db_id"], name: "index_wca_user_data_on_wca_db_id", using: :btree

end
