class BetterRawAlgIndexes < ActiveRecord::Migration
  def change
    remove_index :raw_algs, name: "index_raw_algs_on_length", using: :btree
    remove_index :raw_algs, name: "index_raw_algs_on_position_id_and_length"
    remove_index :raw_algs, name: "index_raw_algs_on_position_id_and_speed"
    remove_index :raw_algs, name: "index_raw_algs_on_position_id"
    remove_index :raw_algs, name: "index_raw_algs_on_speed"

    add_index :raw_algs, [:position_id, :length, :speed]
    add_index :raw_algs, [:position_id, :speed, :length]
    add_index :raw_algs, [:length, :speed]
    add_index :raw_algs, [:speed, :length]
  end
end
