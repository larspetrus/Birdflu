# frozen_string_literal: true

class PositionsController < ApplicationController

  # === Routed action ===
  def index
    @filters = PosSubsets.new(params)
    return redirect_to "/?" + Fields::FILTER_NAMES.map{|k| "#{k}=#{@filters.as_params[k]}"}.join('&') if @filters.reload

    format_params = store_parameters(:format, Fields.defaults(Fields::FORMATS))
    @format = OpenStruct.new(
        list:   Fields::LIST.value(format_params),
        lines:  Fields::LINES.value(format_params),
        sortby: Fields::SORTBY.value(format_params),
    )
    @list_algs = (@format.list == 'algs') || @filters.fully_defined

    query_includes = @list_algs ? :stats : [:stats, :best_alg]
    @positions = Position.where(@filters.where).order(:optimal_alg_length).includes(query_includes).to_a
    @position_ids = @positions.map(&:id)
    @single_position = @positions.first if @filters.fully_defined

    @stats = stats_for_view(@single_position)

    @selected_icons = {}
    Fields::FILTER_NAMES.each{ |f| @selected_icons[f] = Icons::Base.by_code(f, @filters.as_params[f]) }

    @icon_grids = {}
    Fields::FILTER_NAMES.each{ |f| @icon_grids[f] = Icons::Base.class_by(f)::grid  unless f == :ep }
    @icon_grids[:ep] = Icons::Ep.grid_for(@filters.as_params[:cp])

    @list_items =
        @list_algs ?
          RawAlg.where(position_id: @positions.map(&:main_position_id)).includes(:position).order(@format.sortby).limit(@format.lines.to_i) :
          @positions.first(100)

    @svg_ids = Set.new
    @columns = @list_algs ? make_alg_columns : make_pos_columns
    @page_rotation = (params[:prot] || 0).to_i

    if params[:hl_alg]
      @hi_lite = params[:hl_alg]
      @list_items += [DuckRawAlg.new(Algs.rotate_by_U(@hi_lite, -@page_rotation))]
    end
    if params[:hl_id]
      @hi_lite = params[:hl_id].to_i
      @list_items += [RawAlg.find(params[:hl_id].to_i)] unless @list_items.map(&:id).include?(@hi_lite)
    end

    if session[:wca_login]
      if Time.now.to_i > (session[:wca_login]['expires'] || 0)
        session.delete(:wca_login)
      else
        @login_name = session[:wca_login]['name']
      end
    end
  end

  def make_alg_columns
    columns = [Cols::SPEED, Cols::MOVES].rotate(@format.sortby == '_speed' ? 0 : 1)
    columns << Cols::NAME
    columns << Cols::POSITION unless @single_position
    columns << Cols::COP if @selected_icons[:cop].is_none
    columns << Cols::EO  if @selected_icons[:eo].is_none
    columns << Cols::EP  if @selected_icons[:ep].is_none
    columns << Cols::ALG << Cols::SHOW << Cols::NOTES
  end

  def make_pos_columns
    columns = [Cols::POSITION]
    columns << Cols::COP if @selected_icons[:cop].is_none
    columns << Cols::EO  if @selected_icons[:eo].is_none
    columns << Cols::EP  if @selected_icons[:ep].is_none
    columns << Cols::SOLUTIONS << Cols::MOVES_P << Cols::ALG_P << Cols::SHOW
  end

  def stats_for_view(single_pos)
    data = PositionStats.aggregate(@positions.map(&:stats))
    result = OpenStruct.new(sections: [], data: data)

    result.sections << [
        OpenStruct.new(label: 'Shortest', text: data.shortest, class_name: 'optimal'),
        OpenStruct.new(label: 'Fastest',  text: '%.2f' % data.fastest,  class_name: 'optimal'),
    ]
    result.sections << data.raw_counts.keys.sort.map do |length|
      OpenStruct.new(label: "#{length} moves", text: vc.pluralize(data.raw_counts[length], 'alg'))
    end

    if single_pos
      rot_count = single_pos.pov_rotations.count
      rot_s = rot_count == 1 ? '' : 's'

      result.headline = "Position #{single_pos.display_name}"
      result.link_section = [
          { label: 'Mirror', links: single_pos.has_mirror ? [pos_link(single_pos.mirror)]  : ['None'] },
          { label: 'Inverse', links: single_pos.has_inverse ? [pos_link(single_pos.inverse)]  : ['None'] },
          rot_count > 0 ? { label: 'Rotation'+rot_s, links: single_pos.pov_rotations.map{|id| pos_link(Position.find(id)) } } : nil
      ].compact
    else
      result.headline = "#{data.position_count} positions"

      optimal_sum = @positions.reduce(0.0) { |sum, pos| sum + (pos.optimal_alg_length || 100)}
      result.sections[0] << OpenStruct.new(label: "Avg shortest", text: '%.2f' % (optimal_sum/@positions.count))
    end
    result
  end

  def pos_link(pos)
    vc.link_to(pos.display_name,  "positions/#{pos.id}")
  end

  def store_parameters(cookie_name, defaults, new_data = params)
    stored_parameters = defaults.keys
    if new_data.has_key?(stored_parameters.first)
      values = {}
      stored_parameters.each { |k| values[k] = new_data[k] || defaults[k] }
      cookies[cookie_name] = JSON.generate(values)
    else
      values = cookies[cookie_name] ? JSON.parse(cookies[cookie_name], symbolize_names: true) : defaults
    end
    values
  end

  def vc
    view_context
  end

  # === Routed action ===
  def show
    pos = Position.find_by_id(params[:id]) || Position.by_ll_code(params[:id]) || RawAlg.find_with_name(params[:id]).position # Try DB id LL code, or alg name

    new_params = {}
    Fields::FILTER_NAMES.each { |k| new_params[k] = pos[k] }
    new_params[:prot] = params[:prot] if ['1', '2', '3'].include?(params[:prot])
    new_params[:hl_id] = params[:hl_id] if params[:hl_id]
    new_params[:hl_alg] = params[:hl_alg] if params[:hl_alg]

    redirect_to "/?" + new_params.to_query
  end

  # === Routed action ===
  def find_by_alg
    user_input = params[:alg].upcase.strip

    if user_input.include? ' ' # interpret as moves
      actual_moves = user_input
      ll_code = Cube.new(actual_moves).standard_ll_code # raises exception unless alg is good

      db_alg = RawAlg.find_from_moves(user_input, Position.find_by!(ll_code: ll_code))
    else # interpret as alg name
      db_alg = RawAlg.find_with_name(user_input)
      raise "There is no alg named '#{user_input}'" unless db_alg
      actual_moves = db_alg.moves
    end

    result = { ll_code: Cube.new(actual_moves).standard_ll_code, prot: Cube.new(actual_moves).standard_ll_code_offset}
    if db_alg
      result[:alg_id] = db_alg.id
    else
      result[:found_by] = user_input
    end
    render json: result
  rescue Exception => e
    render json: { error: e.message }
  end
end

class DuckRawAlg
  attr_reader :moves, :length, :speed, :name, :css_kind, :pov_offset, :pov_adjust_u_setup, :u_setup, :specialness

  def initialize(moves)
    @moves = moves
    @length  = Algs.length(moves)
    @speed   = Algs.speed_score(moves)
    @u_setup = Algs.standard_u_setup(moves)

    @name = '-'
    @css_kind = ''
    @pov_offset = 0
    @pov_adjust_u_setup = 0
    @specialness = 'Not in DB'
  end

  def matches(search_term)
    true
  end

  def single?
    true
  end
end
