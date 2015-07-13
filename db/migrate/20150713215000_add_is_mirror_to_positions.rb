class AddIsMirrorToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :is_mirror, :boolean
  end
end
