class RemoveRawalgsMirrorid < ActiveRecord::Migration
  def change
    remove_column :raw_algs, :mirror_id, :integer
  end
end
