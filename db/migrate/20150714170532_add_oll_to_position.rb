class AddOllToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :oll, :string
    add_index :positions, :oll
  end
end
