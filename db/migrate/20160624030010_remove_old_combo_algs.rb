class RemoveOldComboAlgs < ActiveRecord::Migration
  def change
    drop_table :old_combo_algs
  end
end
