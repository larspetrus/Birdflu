class ShrinkComboAlgColumns < ActiveRecord::Migration
  def change
    change_column(:combo_algs, :length, :integer, limit: 2)
    change_column(:combo_algs, :u_setup, :integer, limit: 2)
    change_column(:combo_algs, :position_id, :integer, limit: 2)
  end
end
