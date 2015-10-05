class TmeRemoveRawAlgIndexes < ActiveRecord::Migration
  def change
    remove_index :raw_algs, :b_alg
    remove_index :raw_algs, :position_id
  end
end
