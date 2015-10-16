class IndexLikeWeQuery < ActiveRecord::Migration
  def change
    add_index :raw_algs, [:position_id, :length]
    add_index :raw_algs, [:position_id, :speed]

    add_index :combo_algs, [:position_id, :length]
    add_index :combo_algs, [:position_id, :speed]

    add_index :raw_algs, :alg_id

    add_index :positions, :cop
    add_index :positions, :eo
    add_index :positions, :ep
  end
end
