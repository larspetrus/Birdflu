class PositionsController < ApplicationController

  INDEX_FILTERS = [:cop, :eo, :ep, :oll]

  def index
    pos_filter = store_parameters(:pos_filter, {cop: '', eo: '', ep: '', oll: ''})

    @db_query = {}
    INDEX_FILTERS.each { |f| @db_query[f] = pos_filter[f] if pos_filter[f].present? }

    @positions = Position.includes(:best_combo_alg).where(@db_query).to_a.sort_by! {|pos| pos.best_alg_length}
    @position_count = @positions.count

    optimal_sum = @positions.reduce(0.0) { |sum, pos| sum + pos.best_alg_length }
    @optimal_average = '%.2f' % (optimal_sum/@positions.count)

    @positions = @positions.first(100)

    @active_icons = {}
    INDEX_FILTERS.each{ |f| @active_icons[f] = Icons::Base.by_code(f, pos_filter[f]) }
    @icon_grids = {}
    INDEX_FILTERS.each{ |f| @icon_grids[f] = Icons::Base.class_by(f)::grid }

    @joke_header = ['Grail Moth', 'Oral Might', 'A Girl Moth', 'Ham To Girl', 'Roam Light', 'Mortal Sigh', 'A Grim Sloth', 'Glamor Shit', 'Solar Might'].sample
  end

  def show
    @position = Position.by_ll_code(params[:id])
    return redirect_to "/positions/#{Position.find(params[:id]).ll_code}" unless @position

    alg_filter = store_parameters(:alg_filter, {page: 25, algtypes: 'both', sortby: 'speed'})
    @page     = alg_filter[:page].to_i
    @algtypes = alg_filter[:algtypes]
    @sortby   = alg_filter[:sortby]

    @cube = @position.as_cube

    @solutions = Hash.new { |hash, key| hash[key] = Array.new }

    RawAlg.where(position_id: @position.id).order(@sortby).limit(@page).each { |ra| @solutions[[ra[@sortby], ra.moves]] << ra } unless @algtypes == 'combo'
    @position.algs_in_set.order(@sortby).limit(@page).each { |ca| @solutions[[ca[@sortby], ca.moves]] << ca } unless @algtypes == 'single'

    @solution_order = @solutions.keys.sort.first(@page)
    @stats = @position.stats
  end

  def find_by_alg
    alg_from_user = params[:alg].upcase

    if alg_from_user.include? ' '
      actual_alg = alg_from_user
    else
      actual_alg = RawAlg.find_by_alg_id(alg_from_user).try(:moves)
      raise "There is no alg named '#{alg_from_user}'" unless actual_alg
    end
    render json: { ll_code: Cube.new(actual_alg).standard_ll_code}
  rescue Exception => e
    render json: { error: e.message }
  end

  def store_parameters(cookie_name, defaults)
    stored_parameters = defaults.keys
    form_submission = params.has_key?(stored_parameters.first)
    if form_submission
      values = params.select {|k,v| stored_parameters.include? k.to_sym }
      cookies[cookie_name] = JSON.generate(values)
    else
      values = cookies[cookie_name] ? JSON.parse(cookies[cookie_name], symbolize_names: true) : defaults # TODO handle bad cookie
    end
    values
  end
end