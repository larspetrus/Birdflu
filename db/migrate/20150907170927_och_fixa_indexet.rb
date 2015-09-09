class OchFixaIndexet < ActiveRecord::Migration
  def change
    remove_index :raw_algs, :f_alg
    add_index :raw_algs, :b_alg
  end
end
