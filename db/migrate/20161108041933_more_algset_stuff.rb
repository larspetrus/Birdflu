class MoreAlgsetStuff < ActiveRecord::Migration
  def change
    add_column :alg_sets, :predefined, :boolean
    add_column :alg_sets, :wca_user_data_id, :integer
  end
end
