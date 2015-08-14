class PositionsController < ApplicationController

  def index
    form_submitted = params.has_key?(:ol)
    if form_submitted
      form_params = params
      cookies[:form_params] = JSON.generate(params)
    else
      form_params = cookies[:form_params] ? JSON.parse(cookies[:form_params]).with_indifferent_access : {} # TODO handle bad cookie
    end

    @db_query = {}
    @db_query['oll']              = form_params[:ol]      if form_params[:ol].present?
    @db_query['corner_look']      = form_params[:cl]      if form_params[:cl].present?
    @db_query['edge_orientations']= form_params[:eo]      if form_params[:eo].present?
    @db_query['edge_positions']   = form_params[:ep]      if form_params[:ep].present?

    @positions = Position.includes(:best_combo_alg).where(@db_query).to_a.sort_by! {|pos| pos.best_alg_length}
    @position_count = @positions.count

    optimal_sum = @positions.reduce(0.0) { |sum, pos| sum + pos.best_alg_length }
    @optimal_average = '%.2f' % (optimal_sum/@positions.count)

    combo_sum = @positions.reduce(0.0) { |sum, pos| sum + pos.best_combo_alg_length }
    @combo_average = '%.2f' % (combo_sum/@positions.count)

    @positions = @positions.first(100)


    @oll_selected = Icons::Oll.by_code(form_params[:ol])
    @cop_selected = Icons::Cop.by_code(form_params[:cl])
    @eo_selected  = Icons::Eo.by_code(form_params[:eo])
    @ep_selected  = Icons::Ep.by_code(form_params[:ep])

    @oll_rows = Icons::Oll::grid
    @cop_rows = Icons::Cop.grid
    @eo_rows = Icons::Eo::grid
    @ep_rows = Icons::Ep.grid

    @combos = [ComboAlg.where('base_alg2_id is not null').count, ComboAlg.count]

    @joke_header = ['Grail Moth', 'Oral Might', 'A Girl Moth', 'Ham To Girl', 'Roam Light', 'Mortal Sigh', 'A Grim Sloth', 'Glamor Shit', 'Solar Might'].sample
  end

  def show
    @position = Position.by_ll_code(params[:id])
    @top_3 = @position.top_3
    @cube = @position.as_cube
  end
end