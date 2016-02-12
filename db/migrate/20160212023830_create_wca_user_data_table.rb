class CreateWcaUserDataTable < ActiveRecord::Migration
  def change
    create_table :wca_user_data do |t|
      t.integer :wca_db_id
      t.string :wca_id
      t.string :full_name
    end

    add_index :wca_user_data, :wca_db_id
  end
end
