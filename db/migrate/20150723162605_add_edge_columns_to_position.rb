class AddEdgeColumnsToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :edge_orientations, :string
    add_column :positions, :edge_positions, :string
  end
end
