class CreateAlg < ActiveRecord::Migration
  def change
    create_table :algs do |t|
      t.string :name
      t.string :moves
      t.boolean :primary
      t.integer :length
      t.references :position
    end
  end
end
