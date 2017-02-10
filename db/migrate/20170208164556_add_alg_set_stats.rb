class AddAlgSetStats < ActiveRecord::Migration
  def change
    create_table :alg_set_facts do |t|
      t.string :algs_code
      t.float :_avg_length
      t.float :_avg_speed
      t.integer :_coverage
      t.string :_uncovered_ids
    end

    add_index :alg_set_facts, :algs_code

    add_column :alg_sets, :alg_set_fact_id, :integer
  end
end
