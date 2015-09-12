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

ActiveRecord::Schema.define(version: 20150912210345) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "base_algs", force: true do |t|
    t.string  "name"
    t.string  "moves_u0"
    t.string  "moves_u1"
    t.string  "moves_u2"
    t.string  "moves_u3"
    t.integer "root_base_id"
    t.boolean "combined",     default: false
    t.boolean "root_mirror",  default: false
    t.boolean "root_inverse", default: false
  end

  create_table "combo_algs", force: true do |t|
    t.string  "name"
    t.string  "moves"
    t.integer "length"
    t.integer "position_id"
    t.integer "u_setup"
    t.integer "base_alg1_id"
    t.integer "base_alg2_id"
    t.integer "alg2_u_shift"
    t.string  "mv_start"
    t.string  "mv_cancel1"
    t.string  "mv_merged"
    t.string  "mv_cancel2"
    t.string  "mv_end"
    t.boolean "single",       default: false
  end

  add_index "combo_algs", ["base_alg1_id"], name: "index_combo_algs_on_base_alg1_id", using: :btree
  add_index "combo_algs", ["base_alg2_id"], name: "index_combo_algs_on_base_alg2_id", using: :btree
  add_index "combo_algs", ["length"], name: "index_combo_algs_on_length", using: :btree
  add_index "combo_algs", ["position_id"], name: "index_combo_algs_on_position_id", using: :btree

  create_table "positions", force: true do |t|
    t.string  "ll_code"
    t.integer "weight"
    t.integer "corner_swap"
    t.integer "best_alg_id"
    t.integer "alg_count"
    t.string  "mirror_ll_code"
    t.string  "cop"
    t.boolean "is_mirror"
    t.string  "oll"
    t.string  "eo"
    t.string  "ep"
    t.integer "optimal_alg_length"
    t.integer "best_combo_alg_id"
    t.string  "inverse_ll_code"
  end

  add_index "positions", ["ll_code"], name: "index_positions_on_ll_code", using: :btree
  add_index "positions", ["oll"], name: "index_positions_on_oll", using: :btree

  create_table "raw_algs", force: true do |t|
    t.string  "alg_id"
    t.string  "f_alg"
    t.integer "length"
    t.string  "l_alg"
    t.string  "b_alg"
    t.string  "r_alg"
    t.integer "mirror_id"
    t.integer "position_id"
  end

  add_index "raw_algs", ["b_alg"], name: "index_raw_algs_on_b_alg", using: :btree
  add_index "raw_algs", ["position_id"], name: "index_raw_algs_on_position_id", using: :btree

end
