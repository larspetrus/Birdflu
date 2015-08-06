class AddSingleToComboAlg < ActiveRecord::Migration
  def change
    add_column :combo_algs, :single, :boolean, default: false
  end
end
