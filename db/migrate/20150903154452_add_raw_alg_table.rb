class AddRawAlgTable < ActiveRecord::Migration
  def change
    create_table :raw_algs do |t|
      t.string :alg_id
      t.string :f_alg
      t.integer :length
    end
    add_index :raw_algs, :f_alg
  end
end
