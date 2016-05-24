class ComboSpeedToInteger < ActiveRecord::Migration
  def change
    execute "UPDATE combo_algs SET speed=100*speed"
    change_column(:combo_algs, :speed, :integer, limit: 2)
  end
end
