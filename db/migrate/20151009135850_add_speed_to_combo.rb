class AddSpeedToCombo < ActiveRecord::Migration
  def change
    add_column :combo_algs, :speed, :float
  end
end
