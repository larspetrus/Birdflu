class MoreAlgSetFields < ActiveRecord::Migration
  def change
    add_column :alg_sets, :description, :string

    add_column :alg_sets, :created_at, :datetime
    add_column :alg_sets, :updated_at, :datetime
  end
end
