class RenamePovToMain < ActiveRecord::Migration
  def change
    rename_column :positions, :pov_position_id, :main_position_id
  end
end
