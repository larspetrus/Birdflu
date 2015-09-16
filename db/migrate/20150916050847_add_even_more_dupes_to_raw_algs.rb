class AddEvenMoreDupesToRawAlgs < ActiveRecord::Migration
  def change
    add_column :raw_algs, :u_setup, :integer
    add_column :raw_algs, :display_alg, :string
  end
end
