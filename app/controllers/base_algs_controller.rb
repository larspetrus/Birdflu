class BaseAlgsController < ApplicationController
  def index
    BigThought.populate_db
    @root_algs = BaseAlg.where('id = root_base_id').order(:id)
  end

  def combine
    start = Time.now
    @root_ids = params[:rootalgs] || []
    BaseAlg.where(root_base_id: @root_ids).each do |base_alg|
      ComboAlg.find_by!(base_alg1_id: base_alg.id).update(single: false)
      BigThought.combine(base_alg)
    end
    @time = Time.now - start

    respond_to { |format| format.js }
  end

  def update_positions # TODO: Invalidate cache. Handle exceptions
    start = Time.now
    ActiveRecord::Base.transaction do
      alg_counts = ComboAlg.group(:position_id).count
      Position.includes(:combo_algs).find_each do |p|
        p.update(alg_count: alg_counts[p.id], best_combo_alg_id: p.best_combo.try(:id))
      end
    end
    @time = Time.now - start

    respond_to { |format| format.js }
  end
end
