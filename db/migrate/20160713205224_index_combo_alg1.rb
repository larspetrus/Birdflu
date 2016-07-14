class IndexComboAlg1 < ActiveRecord::Migration
  def change
    add_column :combo_algs, :position_id, :integer
    add_index :combo_algs, [:position_id, :alg1_id, :alg2_id]

    execute "UPDATE combo_algs SET position_id=r.position_id FROM raw_algs AS r WHERE combined_alg_id=r.id"
  end
end
