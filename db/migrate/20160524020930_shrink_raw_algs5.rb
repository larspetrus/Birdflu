class ShrinkRawAlgs5 < ActiveRecord::Migration
  def change
    remove_column :raw_algs, :combined, :boolean
  end
end
