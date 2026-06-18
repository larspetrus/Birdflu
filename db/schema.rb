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

ActiveRecord::Schema[8.1].define(version: 2017_03_13_021324) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "alg_set_facts", force: :cascade do |t|
    t.float "_avg_length"
    t.float "_avg_speed"
    t.integer "_coverage"
    t.string "_uncovered_ids"
    t.string "algs_code"
    t.index ["algs_code"], name: "index_alg_set_facts_on_algs_code"
  end

  create_table "alg_sets", force: :cascade do |t|
    t.integer "alg_set_fact_id"
    t.string "algs"
    t.datetime "created_at"
    t.string "description"
    t.string "name"
    t.boolean "predefined"
    t.string "subset"
    t.datetime "updated_at"
    t.integer "wca_user_id"
  end

  create_table "combo_algs", force: :cascade do |t|
    t.integer "alg1_id"
    t.integer "alg2_id"
    t.integer "combined_alg_id"
    t.integer "encoded_data", limit: 2
    t.integer "position_id", limit: 2
    t.index ["combined_alg_id"], name: "index_combo_algs_on_combined_alg_id"
    t.index ["position_id", "alg1_id", "alg2_id"], name: "index_combo_algs_on_position_id_and_alg1_id_and_alg2_id"
  end

  create_table "galaxies", force: :cascade do |t|
    t.string "starred_type"
    t.integer "style", limit: 2
    t.integer "wca_user_id"
    t.index ["wca_user_id"], name: "index_galaxies_on_wca_user_id"
  end

  create_table "position_stats", force: :cascade do |t|
    t.string "marshaled_stats", limit: 255
    t.integer "position_id"
    t.index ["position_id"], name: "index_position_stats_on_position_id"
  end

  create_table "positions", force: :cascade do |t|
    t.integer "best_alg_id"
    t.string "co", limit: 255
    t.string "cop", limit: 255
    t.string "cp", limit: 255
    t.string "eo", limit: 255
    t.string "ep", limit: 255
    t.integer "inverse_id"
    t.string "ll_code", limit: 255
    t.integer "main_position_id"
    t.integer "mirror_id"
    t.string "oll", limit: 255
    t.integer "optimal_alg_length"
    t.integer "pov_offset"
    t.integer "weight"
    t.index ["cop"], name: "index_positions_on_cop"
    t.index ["eo"], name: "index_positions_on_eo"
    t.index ["ep"], name: "index_positions_on_ep"
    t.index ["ll_code"], name: "index_positions_on_ll_code"
    t.index ["oll"], name: "index_positions_on_oll"
    t.index ["optimal_alg_length", "cop", "eo", "ep"], name: "index_positions_on_optimal_alg_length_and_cop_and_eo_and_ep"
  end

  create_table "raw_algs", force: :cascade do |t|
    t.string "_moves"
    t.integer "_speed", limit: 2
    t.integer "length", limit: 2
    t.integer "position_id", limit: 2
    t.string "specialness", limit: 255
    t.integer "u_setup", limit: 2
    t.index ["_speed", "length"], name: "index_raw_algs_on__speed_and_length"
    t.index ["length", "_speed"], name: "index_raw_algs_on_length_and__speed"
    t.index ["position_id", "_speed", "length"], name: "index_raw_algs_on_position_id_and__speed_and_length"
    t.index ["position_id", "length", "_speed"], name: "index_raw_algs_on_position_id_and_length_and__speed"
  end

  create_table "stars", force: :cascade do |t|
    t.integer "galaxy_id"
    t.integer "starred_id"
    t.index ["galaxy_id"], name: "index_stars_on_galaxy_id"
    t.index ["starred_id"], name: "index_stars_on_starred_id"
  end

  create_table "wca_users", force: :cascade do |t|
    t.datetime "created_at"
    t.string "full_name"
    t.datetime "updated_at"
    t.integer "wca_db_id"
    t.string "wca_id"
    t.index ["wca_db_id"], name: "index_wca_users_on_wca_db_id"
  end
end
