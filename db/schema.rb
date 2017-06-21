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

ActiveRecord::Schema.define(version: 20170313021324) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alg_set_facts", force: :cascade do |t|
    t.string  "algs_code"
    t.float   "_avg_length"
    t.float   "_avg_speed"
    t.integer "_coverage"
    t.string  "_uncovered_ids"
    t.index ["algs_code"], name: "index_alg_set_facts_on_algs_code", using: :btree
  end

  create_table "alg_sets", force: :cascade do |t|
    t.string   "name"
    t.string   "algs"
    t.string   "subset"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "predefined"
    t.integer  "wca_user_id"
    t.integer  "alg_set_fact_id"
  end

  create_table "combo_algs", force: :cascade do |t|
    t.integer "alg1_id"
    t.integer "alg2_id"
    t.integer "combined_alg_id"
    t.integer "encoded_data",    limit: 2
    t.integer "position_id",     limit: 2
    t.index ["combined_alg_id"], name: "index_combo_algs_on_combined_alg_id", using: :btree
    t.index ["position_id", "alg1_id", "alg2_id"], name: "index_combo_algs_on_position_id_and_alg1_id_and_alg2_id", using: :btree
  end

  create_table "galaxies", force: :cascade do |t|
    t.integer "wca_user_id"
    t.integer "style",        limit: 2
    t.string  "starred_type"
    t.index ["wca_user_id"], name: "index_galaxies_on_wca_user_id", using: :btree
  end

  create_table "position_stats", force: :cascade do |t|
    t.integer "position_id"
    t.string  "marshaled_stats", limit: 255
    t.index ["position_id"], name: "index_position_stats_on_position_id", using: :btree
  end

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
    t.index ["cop"], name: "index_positions_on_cop", using: :btree
    t.index ["eo"], name: "index_positions_on_eo", using: :btree
    t.index ["ep"], name: "index_positions_on_ep", using: :btree
    t.index ["ll_code"], name: "index_positions_on_ll_code", using: :btree
    t.index ["oll"], name: "index_positions_on_oll", using: :btree
    t.index ["optimal_alg_length", "cop", "eo", "ep"], name: "index_positions_on_optimal_alg_length_and_cop_and_eo_and_ep", using: :btree
  end

  create_table "raw_algs", force: :cascade do |t|
    t.integer "length",      limit: 2
    t.integer "position_id", limit: 2
    t.integer "u_setup",     limit: 2
    t.string  "specialness", limit: 255
    t.integer "_speed",      limit: 2
    t.string  "_moves"
    t.index ["_speed", "length"], name: "index_raw_algs_on__speed_and_length", using: :btree
    t.index ["length", "_speed"], name: "index_raw_algs_on_length_and__speed", using: :btree
    t.index ["position_id", "_speed", "length"], name: "index_raw_algs_on_position_id_and__speed_and_length", using: :btree
    t.index ["position_id", "length", "_speed"], name: "index_raw_algs_on_position_id_and_length_and__speed", using: :btree
  end

  create_table "stars", force: :cascade do |t|
    t.integer "galaxy_id"
    t.integer "starred_id"
    t.index ["galaxy_id"], name: "index_stars_on_galaxy_id", using: :btree
    t.index ["starred_id"], name: "index_stars_on_starred_id", using: :btree
  end

  create_table "wca_users", force: :cascade do |t|
    t.integer  "wca_db_id"
    t.string   "wca_id"
    t.string   "full_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["wca_db_id"], name: "index_wca_users_on_wca_db_id", using: :btree
  end

end
