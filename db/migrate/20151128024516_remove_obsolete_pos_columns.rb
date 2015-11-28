class RemoveObsoletePosColumns < ActiveRecord::Migration
  def change
    remove_column :positions, :mirror_ll_code, :string
    remove_column :positions, :inverse_ll_code, :string
    remove_column :positions, :is_mirror, :boolean

  end
end
