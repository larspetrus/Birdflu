class ShrinkRawAlgs1 < ActiveRecord::Migration
  def change
    change_column(:raw_algs, :length, :integer, limit: 2)
  end
end
