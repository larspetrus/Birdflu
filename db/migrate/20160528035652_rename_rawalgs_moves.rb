class RenameRawalgsMoves < ActiveRecord::Migration
  def change
    rename_column :raw_algs, :moves, :big_moves
  end
end
