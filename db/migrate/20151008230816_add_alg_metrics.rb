class AddAlgMetrics < ActiveRecord::Migration
  def change
    add_column :raw_algs, :specialness, :string
    add_column :raw_algs, :speed, :float
  end
end
