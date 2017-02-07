class AddMeasuresToAlgSet < ActiveRecord::Migration
  def change
    add_column :alg_sets, :_avg_length, :float
    add_column :alg_sets, :_avg_speed, :float
    add_column :alg_sets, :_coverage, :integer
    add_column :alg_sets, :_uncovered_ids, :string
  end
end
