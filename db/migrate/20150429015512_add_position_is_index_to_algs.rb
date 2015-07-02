class AddPositionIsIndexToAlgs < ActiveRecord::Migration
  def change
    add_index :algs, :position_id
  end
end
