class AddStuffToBasealgs < ActiveRecord::Migration
  def change
    add_column :base_algs, :root_mirror, :boolean, default: false
    add_column :base_algs, :root_inverse, :boolean, default: false
  end
end
