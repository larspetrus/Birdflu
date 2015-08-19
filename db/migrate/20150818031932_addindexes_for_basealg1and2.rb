class AddindexesForBasealg1and2 < ActiveRecord::Migration
  def change
    add_index :combo_algs, :base_alg1_id
    add_index :combo_algs, :base_alg2_id
  end
end
