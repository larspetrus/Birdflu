class AdjustComboAlgColumnSizes < ActiveRecord::Migration
  def change
    change_column(:combo_algs, :alg1_id, :integer, limit: 4)
    change_column(:combo_algs, :alg2_id, :integer, limit: 4)
    change_column(:combo_algs, :position_id, :integer, limit: 2)
  end
end
