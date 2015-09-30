class RemoveBaseAlg < ActiveRecord::Migration
  def change
    drop_table :base_algs
    remove_column :combo_algs, :single
  end
end
