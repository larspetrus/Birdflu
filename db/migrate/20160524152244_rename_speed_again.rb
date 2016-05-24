class RenameSpeedAgain < ActiveRecord::Migration
  def change
    rename_column :raw_algs  , :_speed_int, :_speed
    rename_column :combo_algs, :_speed_int, :_speed
  end
end
