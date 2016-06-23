class OrderPositionsAlphabetically < ActiveRecord::Migration
  def change
    add_index :positions, [:optimal_alg_length, :cop, :eo, :ep]
  end
end
