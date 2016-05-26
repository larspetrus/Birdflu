class RemoveBestComboAlgId < ActiveRecord::Migration
  def change
    remove_column :positions, :best_combo_alg_id, :integer
  end
end
