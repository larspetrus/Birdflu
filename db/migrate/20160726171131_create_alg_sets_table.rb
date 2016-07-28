class CreateAlgSetsTable < ActiveRecord::Migration
  def change
    create_table :alg_sets do |t|
      t.string :name
      t.string :algs
      t.string :_cached_data
    end
  end
end
