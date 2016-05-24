class ShrinkRawAlgs3 < ActiveRecord::Migration
  def change
    change_column(:raw_algs, :position_id, :integer, limit: 2)
  end
end
