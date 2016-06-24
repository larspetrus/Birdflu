class RemoveAlgCount < ActiveRecord::Migration
  def change
    remove_column :positions, :alg_count
  end
end
