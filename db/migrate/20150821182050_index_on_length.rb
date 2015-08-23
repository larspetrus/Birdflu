class IndexOnLength < ActiveRecord::Migration
  def change
    add_index :combo_algs, :length
  end
end
