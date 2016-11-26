class AddStars < ActiveRecord::Migration
  def change
    create_table :galaxies do |t|
      t.integer :wca_user_data_id
      t.integer :style,      limit: 2
    end

    create_table :stars do |t|
      t.integer :galaxy_id
      t.integer :raw_alg_id
    end
  end
end
