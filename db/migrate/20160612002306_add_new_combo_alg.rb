class AddNewComboAlg < ActiveRecord::Migration
  def change
    create_table :combo_algs do |t|
      t.integer :alg1_id, :integer, limit: 2
      t.integer :alg2_id, :integer, limit: 2
      t.integer :combined_alg_id, :integer
      t.integer :encoded_data, :integer, limit: 2
    end

    add_index :combo_algs, :combined_alg_id
  end
end
