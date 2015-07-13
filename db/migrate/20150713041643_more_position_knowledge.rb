class MorePositionKnowledge < ActiveRecord::Migration
  def change
    add_column :positions, :mirror_ll_code, :string
    add_column :positions, :corner_look, :string
  end
end
