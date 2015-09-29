class PositionsController < ApplicationController

  FILTERS = [:cop, :eo, :ep, :oll]

  def index
    form_submitted = params.has_key?(FILTERS.first)
    if form_submitted
      form_params = params
      cookies[:form_params] = JSON.generate(params)
    else
      form_params = cookies[:form_params] ? JSON.parse(cookies[:form_params]).with_indifferent_access : {} # TODO handle bad cookie
    end

    @db_query = {}
    FILTERS.each { |f| @db_query[f] = form_params[f] if form_params[f].present? }

    @positions = Position.includes(:best_combo_alg).where(@db_query).to_a.sort_by! {|pos| pos.best_alg_length}
    @position_count = @positions.count

    optimal_sum = @positions.reduce(0.0) { |sum, pos| sum + pos.best_alg_length }
    @optimal_average = '%.2f' % (optimal_sum/@positions.count)

    combo_sum = @positions.reduce(0.0) { |sum, pos| sum + pos.best_combo_alg_length }
    @combo_average = '%.2f' % (combo_sum/@positions.count)

    algset_sum = @positions.reduce(0.0) { |sum, pos| sum + pos.best_alg_set_length }
    @algset_average = '%.2f' % (algset_sum/@positions.count)

    @set_solved = @positions.reduce(0) do |sum, pos|
        sum += pos.best_alg_set_length < 99 ? 1 : 0
    end

    @positions = @positions.first(100)

    @active_icons = {}
    FILTERS.each{ |f| @active_icons[f] = Icons::Base.by_code(f, form_params[f]) }
    @icon_grids = {}
    FILTERS.each{ |f| @icon_grids[f] = Icons::Base.class_by(f)::grid }

    @counts = [RawAlg.count, ComboAlg.count]

    @joke_header = ['Grail Moth', 'Oral Might', 'A Girl Moth', 'Ham To Girl', 'Roam Light', 'Mortal Sigh', 'A Grim Sloth', 'Glamor Shit', 'Solar Might'].sample
  end

  def show
    @position = Position.by_ll_code(params[:id])
    @cube = @position.as_cube
    @algs = (@position.algs_in_set + RawAlg.where(position_id: @position.id, length: @position.optimal_alg_length)).sort_by{|alg| [alg.length, alg.moves]}
    @top_3 = @algs.first(3)
  end
end