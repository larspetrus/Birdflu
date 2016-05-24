class RenameSpeed < ActiveRecord::Migration
  def change
    rename_column :raw_algs, :speed, :_speed_int
    rename_column :combo_algs, :speed, :_speed_int
  end
end
