class KillAccidentalColumn < ActiveRecord::Migration
  def change
    remove_column :combo_algs, :integer
  end
end
