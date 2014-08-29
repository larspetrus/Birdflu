class CreateAlgs < ActiveRecord::Migration
  def change
    create_table :algs do |t|
      t.string :moves
      t.string :solves_code

      t.timestamps
    end
  end
end
