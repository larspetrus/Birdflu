class RemoveOrientedCountsFromPosition < ActiveRecord::Migration
  def change
    remove_column :positions, :oriented_edges, :integer
    remove_column :positions, :oriented_corners, :integer
  end
end
