class AddMirrorIdToRawAlgs < ActiveRecord::Migration
  def change
    add_column :raw_algs, :mirror_id, :integer
  end
end
