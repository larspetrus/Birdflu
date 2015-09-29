class AddCombinedToRawAlgs < ActiveRecord::Migration
  def change
    add_column :raw_algs, :combined, :boolean, default: false
  end
end
