class AllVariationsInRawAlgs < ActiveRecord::Migration
  def change
    add_column :raw_algs, :l_alg, :string
    add_column :raw_algs, :b_alg, :string
    add_column :raw_algs, :r_alg, :string
  end
end
