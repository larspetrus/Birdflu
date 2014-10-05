class AddManyColumns < ActiveRecord::Migration
  def change
    add_column :algs, :kind, :string
    add_column :algs, :u_setup, :integer
    add_column :algs, :alg1_id, :integer
    add_column :algs, :alg2_id, :integer
    remove_column :algs, :primary, :boolean

    add_index :positions, :ll_code
    add_column :positions, :weight, :integer
    add_column :positions, :oriented_edges, :integer
    add_column :positions, :oriented_corners, :integer
    add_column :positions, :corner_swap, :integer
  end
end
