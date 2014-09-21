class AddCpToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :corner_swap, :integer
  end
end
