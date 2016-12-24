class ComboStars < ActiveRecord::Migration
  def change
    rename_column :stars, :raw_alg_id, :starred_id
    add_column :galaxies, :starred_type, :string

    execute "UPDATE galaxies SET starred_type = 'raw_alg'"
  end
end
