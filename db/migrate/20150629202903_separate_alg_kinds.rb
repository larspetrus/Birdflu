class SeparateAlgKinds < ActiveRecord::Migration
  def change
    create_table :base_algs do |t|
      t.string :name
      t.string :moves_u0
      t.string :moves_u1
      t.string :moves_u2
      t.string :moves_u3
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
    end

    add_index "combo_algs", ["position_id"], name: "index_combo_algs_on_position_id", using: :btree
  end
end
