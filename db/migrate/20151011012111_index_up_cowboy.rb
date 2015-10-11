class IndexUpCowboy < ActiveRecord::Migration
  def change
    add_index :raw_algs, :length
    add_index :raw_algs, :speed
    add_index :combo_algs, :speed
  end
end
