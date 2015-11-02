class PositionsController < ApplicationController

  POSITION_FILTERS = [:cop, :oll, :co, :cp, :eo, :ep]

  def index
    effective_pos_params = {}

    if params[:clicked]
      effective_pos_params = PosSubsets.selected_subsets(params)
    end

    @filters = store_parameters(:pos_filter, {cop: '',oll: '',co: '',cp: '', eo: '', ep: ''}, effective_pos_params)
    @single_position = @filters[:cop].present? && @filters[:eo].present? && @filters[:ep].present?
    @page_format = @single_position ? 'algs' : store_parameters(:page, {page_format: 'positions'})[:page_format]

    includes = (@page_format == 'algs') ? :stats : [:stats, :best_alg]
    @positions = Position.where(@filters.select{|k,v| v.present?}).order(:optimal_alg_length).includes(includes).to_a
    optimal_sum = @positions.reduce(0.0) { |sum, pos| sum + (pos.optimal_alg_length || 100)}
    @shortest_average = '%.2f' % (optimal_sum/@positions.count)

    @aggregate_stats = PositionStats.aggregate(@positions.map(&:stats))
    @positions = @positions.first(100)

    @page_stats = stats_for_view(@single_position ? @positions.first : nil, @aggregate_stats)

    @selected_icons = {}
    POSITION_FILTERS.each{ |f| @selected_icons[f] = Icons::Base.by_code(f, @filters[f]) }

    @icon_grids = {}
    POSITION_FILTERS.each{ |f| @icon_grids[f] = Icons::Base.class_by(f)::grid  unless f == :ep }
    @icon_grids[:ep] = Icons::Ep.grid_for(@filters[:cp])

    if @single_position
      @single_position = @positions.first
    end

    if @page_format == 'algs'
      alg_list_settings
      @raw_algs = RawAlg.where(position_id: @positions.map(&:id)).includes(:position).order(@sortby).limit(@page)
    end
    @svg_ids = Set.new
  end

  def stats_for_view(single_pos, stats)
    result = OpenStruct.new(sections: [])

    result.sections << [
        OpenStruct.new(label: 'Shortest', text: stats.shortest, class_name: 'optimal'),
        OpenStruct.new(label: 'Fastest',  text: stats.fastest,  class_name: 'optimal'),
    ]
    result.sections << stats.raw_counts.keys.sort.map do |length|
      OpenStruct.new(label: "#{length} moves", text: "#{view_context.pluralize(stats.raw_counts[length], 'alg')}")
    end

    if single_pos
      result.headline = "Position #{single_pos.display_name}"
      result.link_section = [
          single_pos.has_mirror  ? view_context.link_to("Mirror - #{single_pos.mirror.display_name}",   "positions/#{single_pos.mirror_ll_code}")  : "No mirror",
          single_pos.has_inverse ? view_context.link_to("Inverse - #{single_pos.inverse.display_name}", "positions/#{single_pos.inverse_ll_code}") : "No inverse",
      ]
    else
      result.headline = "#{stats.position_count} positions"
      result.sections[0] << OpenStruct.new(label: "Avg shortest", text: @shortest_average)
    end
    result
  end

  def show
    pos = Position.by_ll_code(params[:id]) || Position.find_by_id(params[:id]) || RawAlg.find_by_alg_id(params[:id]).position # Try LL code, DB id or alg name
    store_parameters(:pos_filter, {cop: '',oll: '',co: '',cp: '', eo: '', ep: ''}, {cop: pos.cop, oll: pos.oll, co: pos.co, cp: pos.cp, eo: pos.eo, ep: pos.ep})
    return redirect_to "/"
    #
    # alg_list_settings
    #
    # @solutions = Hash.new { |hash, key| hash[key] = Array.new }
    #
    # RawAlg.where(position_id: @position.id).order(@sortby).limit(@page).each { |ra| @solutions[[ra[@sortby], ra.moves]] << ra } unless @algtypes == 'combo'
    # @position.algs_in_set.order(@sortby).limit(@page).each { |ca| @solutions[[ca[@sortby], ca.moves]] << ca } unless @algtypes == 'single'
    #
    # @solution_order = @solutions.keys.sort.first(@page)
    # @stats = @position.stats
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

  def store_parameters(cookie_name, defaults, new_data = params)
    stored_parameters = defaults.keys
    if new_data.has_key?(stored_parameters.first)
      values = new_data.select {|k,v| stored_parameters.include? k.to_sym }
      cookies[cookie_name] = JSON.generate(values)
    else
      values = cookies[cookie_name] ? JSON.parse(cookies[cookie_name], symbolize_names: true) : defaults # TODO handle bad cookie
    end
    values
  end

  def alg_list_settings
    alg_list_params = store_parameters(:alg_filter, {page: 25, algtypes: 'both', sortby: 'speed'})
    @page     = alg_list_params[:page].to_i
    @algtypes = alg_list_params[:algtypes]
    @sortby   = alg_list_params[:sortby]
  end
end