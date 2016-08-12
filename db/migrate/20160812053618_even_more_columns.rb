class EvenMoreColumns < ActiveRecord::Migration
  def change
    add_column(:alg_sets, :subset, :string)
    execute "UPDATE alg_sets SET subset='all'"

    add_column(:wca_user_data, :created_at, :datetime)
    add_column(:wca_user_data, :updated_at, :datetime)
  end
end
