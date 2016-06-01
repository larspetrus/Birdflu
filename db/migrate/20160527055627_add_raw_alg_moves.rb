class AddRawAlgMoves < ActiveRecord::Migration
  def change
    add_column :raw_algs, :_moves, :string
  end
end
