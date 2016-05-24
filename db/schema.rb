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

ActiveRecord::Schema.define(version: 20160524152244) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "combo_algs", force: :cascade do |t|
    t.string  "name",         limit: 255
    t.string  "moves",        limit: 255
    t.integer "length",       limit: 2
    t.integer "position_id",  limit: 2
    t.integer "u_setup",      limit: 2
    t.integer "base_alg1_id"
    t.integer "base_alg2_id"
    t.integer "alg2_u_shift"
    t.string  "mv_start",     limit: 255
    t.string  "mv_cancel1",   limit: 255
    t.string  "mv_merged",    limit: 255
    t.string  "mv_cancel2",   limit: 255
    t.string  "mv_end",       limit: 255
    t.integer "_speed",       limit: 2
  end

  add_index "combo_algs", ["_speed"], name: "index_combo_algs_on__speed", using: :btree
  add_index "combo_algs", ["base_alg1_id"], name: "index_combo_algs_on_base_alg1_id", using: :btree
  add_index "combo_algs", ["base_alg2_id"], name: "index_combo_algs_on_base_alg2_id", using: :btree
  add_index "combo_algs", ["length"], name: "index_combo_algs_on_length", using: :btree
  add_index "combo_algs", ["position_id", "_speed"], name: "index_combo_algs_on_position_id_and__speed", using: :btree
  add_index "combo_algs", ["position_id", "length"], name: "index_combo_algs_on_position_id_and_length", using: :btree
  add_index "combo_algs", ["position_id"], name: "index_combo_algs_on_position_id", using: :btree

  create_table "position_stats", force: :cascade do |t|
    t.integer "position_id"
    t.string  "marshaled_stats", limit: 255
  end

  add_index "position_stats", ["position_id"], name: "index_position_stats_on_position_id", using: :btree

  create_table "positions", force: :cascade do |t|
    t.string  "ll_code",            limit: 255
    t.integer "weight"
    t.integer "best_alg_id"
    t.integer "alg_count"
    t.string  "cop",                limit: 255
    t.string  "oll",                limit: 255
    t.string  "eo",                 limit: 255
    t.string  "ep",                 limit: 255
    t.integer "optimal_alg_length"
    t.integer "best_combo_alg_id"
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

  create_table "raw_algs", force: :cascade do |t|
    t.string  "alg_id",      limit: 255
    t.integer "length",      limit: 2
    t.integer "position_id", limit: 2
    t.integer "mirror_id"
    t.integer "u_setup",     limit: 2
    t.string  "specialness", limit: 255
    t.integer "_speed",      limit: 2
    t.string  "moves",       limit: 255
  end

  add_index "raw_algs", ["_speed", "length"], name: "index_raw_algs_on__speed_and_length", using: :btree
  add_index "raw_algs", ["alg_id"], name: "index_raw_algs_on_alg_id", using: :btree
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
