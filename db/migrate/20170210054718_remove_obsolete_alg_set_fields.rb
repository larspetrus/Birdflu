class RemoveObsoleteAlgSetFields < ActiveRecord::Migration
  def change
    remove_column :alg_sets, :_cached_data
    remove_column :alg_sets, :_avg_length
    remove_column :alg_sets, :_avg_speed
    remove_column :alg_sets, :_coverage
    remove_column :alg_sets, :_uncovered_ids
  end
end
