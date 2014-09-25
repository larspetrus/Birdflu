class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :ll_code
    end
  end
end
