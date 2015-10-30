class RemoveCornerSwap < ActiveRecord::Migration
  def change
    remove_column :positions, :corner_swap, :integer
  end
end
