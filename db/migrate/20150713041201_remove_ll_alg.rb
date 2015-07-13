class RemoveLlAlg < ActiveRecord::Migration
  def change
    drop_table :algs
  end
end
