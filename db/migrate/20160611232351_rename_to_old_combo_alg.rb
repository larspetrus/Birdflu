class RenameToOldComboAlg < ActiveRecord::Migration
  def change
    rename_table :combo_algs, :old_combo_algs
  end
end
