class ShrinkRawAlgs2 < ActiveRecord::Migration
  def change
    change_column(:raw_algs, :u_setup, :integer, limit: 2)
  end
end
