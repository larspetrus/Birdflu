class AddSpeedupStuff < ActiveRecord::Migration
  def change
    add_column :raw_algs, :moves, :string

    create_table :position_stats do |t|
      t.integer :position_id
      t.string :marshaled_stats
    end
    add_index :position_stats, :position_id
  end
end
