class JustSomePolish < ActiveRecord::Migration
  def change
    rename_table :wca_user_data, :wca_users

    rename_column :alg_sets, :wca_user_data_id, :wca_user_id
    rename_column :galaxies, :wca_user_data_id, :wca_user_id

    add_index :galaxies, :wca_user_id
    add_index :stars, :galaxy_id
    add_index :stars, :raw_alg_id
  end
end
