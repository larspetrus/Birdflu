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

ActiveRecord::Schema.define(version: 20140917163648) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "algs", force: true do |t|
    t.string  "name"
    t.string  "moves"
    t.integer "length"
    t.integer "position_id"
    t.string  "kind"
    t.integer "u_setup"
    t.integer "alg1_id"
    t.integer "alg2_id"
    t.string  "mv_start"
    t.string  "mv_cancel1"
    t.string  "mv_merged"
    t.string  "mv_cancel2"
    t.string  "mv_end"
  end

  create_table "positions", force: true do |t|
    t.string   "ll_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "oriented_edges"
    t.integer  "oriented_corners"
    t.integer  "best_alg_id"
    t.integer  "alg_count"
  end

  add_index "positions", ["ll_code"], name: "index_positions_on_ll_code", using: :btree

end
