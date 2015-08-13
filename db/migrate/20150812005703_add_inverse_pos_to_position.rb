class AddInversePosToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :inverse_ll_code, :string
  end
end
