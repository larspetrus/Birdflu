class BaseAlgsController < ApplicationController
  def index
    BigThought.populate_db
    @root_algs = BaseAlg.order(:id)
    @counts = ComboAlg.group(:base_alg1_id).count
  end

  def combine
    start = Time.now
    BigThought.combine(BaseAlg.find(params[:id]))
    @time = Time.now - start

    respond_to { |format| format.js }
  end

  def update_positions
    start = Time.now
    ActiveRecord::Base.transaction do
      alg_counts = ComboAlg.group(:position_id).count
      Position.find_each do |p|
        p.update(alg_count: alg_counts[p.id], best_alg_id: p.combo_algs[0].try(:id))
      end
    end
    @time = Time.now - start

    respond_to { |format| format.js }
  end
end
