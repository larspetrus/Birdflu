class RawAlgIndexOnPosId < ActiveRecord::Migration
  def change
    add_index :raw_algs, :position_id
  end
end
