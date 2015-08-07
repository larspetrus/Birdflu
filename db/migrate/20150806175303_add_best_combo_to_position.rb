class AddBestComboToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :best_combo_alg_id, :integer
  end
end
