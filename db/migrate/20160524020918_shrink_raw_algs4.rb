class ShrinkRawAlgs4 < ActiveRecord::Migration
  def change
    execute "UPDATE raw_algs SET speed=100*speed"
    change_column(:raw_algs, :speed, :integer, limit: 2)
  end
end
