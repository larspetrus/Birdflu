class ThisIsGettingSilly < ActiveRecord::Migration
  def change
    drop_table :raw_algs

    create_table "raw_algs", force: true do |t|
      t.string  "alg_id"
      t.integer "length"
      t.integer "position_id"
      t.string  "b_alg"
      t.string  "r_alg"
      t.string  "f_alg"
      t.string  "l_alg"
      t.integer "mirror_id"
      t.string  "display_alg"
      t.integer "u_setup"
      t.boolean "combined",    default: false
    end

    add_index "raw_algs", ["b_alg"], name: "index_raw_algs_on_b_alg", using: :btree
    add_index "raw_algs", ["position_id"], name: "index_raw_algs_on_position_id", using: :btree
  end
end
