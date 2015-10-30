class AddCoAndCpToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :co, :string
    add_column :positions, :cp, :string
  end
end
