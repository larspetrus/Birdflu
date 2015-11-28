class Ugh < ActiveRecord::Migration
  def change
    rename_column :positions, :mirror_ll_id, :mirror_id
    rename_column :positions, :inverse_ll_id, :inverse_id
  end
end
