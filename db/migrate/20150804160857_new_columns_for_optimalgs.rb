class NewColumnsForOptimalgs < ActiveRecord::Migration
  def change
    add_column :positions, :optimal_alg_length, :integer

    add_column :base_algs, :root_base_id, :integer
    add_column :base_algs, :combined, :boolean, default: false
  end
end
