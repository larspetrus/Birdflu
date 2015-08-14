class RenamePosColumns < ActiveRecord::Migration
  def change
    rename_column :positions, :corner_look, :cop
    rename_column :positions, :edge_orientations, :eo
    rename_column :positions, :edge_positions, :ep
  end
end
