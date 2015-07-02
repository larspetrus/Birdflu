class BaseAlgsController < ApplicationController
  def index
    @root_algs = BaseAlg.order(:id)
  end

  def combine
    start = Time.now
    BigThought.combine(BaseAlg.find(params[:id]))
    @time = Time.now - start

    respond_to { |format| format.js }
  end

  def update_positions
    start = Time.now
    Position.find_each { |p| p.update(alg_count: p.combo_algs.count, best_alg_id: p.combo_algs[0].try(:id)) }
    @time = Time.now - start

    respond_to { |format| format.js }
  end
end
