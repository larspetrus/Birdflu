class UseIdsNotLlCodes < ActiveRecord::Migration
  def change
    add_column :positions, :mirror_ll_id, :integer
    add_column :positions, :inverse_ll_id, :integer

    Position.update_each do |pos|
      pos.mirror_ll_id  = Position.find_by_ll_code(pos.mirror_ll_code).id
      pos.inverse_ll_id = Position.find_by_ll_code(pos.inverse_ll_code).id
    end
  end
end
