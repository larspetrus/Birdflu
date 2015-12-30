class AddAlternatePovPositions < ActiveRecord::Migration
  def change
    add_column :positions, :pov_position_id, :integer
    add_column :positions, :pov_offset, :integer
  end
end
