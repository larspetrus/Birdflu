class RemoveObsoleteRawAlgStuff < ActiveRecord::Migration
  def change
    remove_column :raw_algs, :b_alg, :string
    remove_column :raw_algs, :r_alg, :string
    remove_column :raw_algs, :f_alg, :string
    remove_column :raw_algs, :l_alg, :string
    remove_column :raw_algs, :display_alg, :string
  end
end
