class RemoveUncompressedMoves < ActiveRecord::Migration
  def change
    remove_column :raw_algs, :big_moves, :string
  end
end
