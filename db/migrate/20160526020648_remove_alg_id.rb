class RemoveAlgId < ActiveRecord::Migration
  def change
    remove_column :raw_algs, :alg_id, :string
  end
end
