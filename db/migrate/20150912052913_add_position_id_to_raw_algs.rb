class AddPositionIdToRawAlgs < ActiveRecord::Migration
  def change
    add_column :raw_algs, :position_id, :integer
  end
end
