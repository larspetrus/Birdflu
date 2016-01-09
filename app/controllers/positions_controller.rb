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
          RawAlg.where(position_id: @positions.map(&:pov_position_id)).includes(:position).order(@format.sortby).limit(@format.lines.to_i) :
          @positions.first(100)

    @svg_ids = Set.new
    @columns = @list_algs ? make_alg_columns : make_pos_columns
    @u_rotation = (params[:urot] || 0).to_i
  end

  def make_alg_columns
    columns = [Cols::SPEED, Cols::MOVES].rotate(@format.sortby == 'speed' ? 0 : 1)
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

  # === Routed action ===
  def show
    pos = Position.find_by_id(params[:id]) || Position.by_ll_code(params[:id]) || RawAlg.find_by_alg_id(params[:id]).position # Try DB id LL code, or alg name
    urot_param = ['1', '2', '3'].include?(params[:urot]) ? '&urot=' + params[:urot] : ''
    redirect_to "/?" + Fields::FILTER_NAMES.map{|k| "#{k}=#{pos[k]}"}.join('&') + urot_param
  end

  # === Routed action ===
  def find_by_alg
    moves_from_user = params[:alg].upcase

    if moves_from_user.include? ' '
      actual_moves = moves_from_user
    else
      actual_moves = RawAlg.find_by_alg_id(moves_from_user).try(:moves)
      raise "There is no alg named '#{moves_from_user}'" unless actual_moves
    end
    render json: { ll_code: Cube.new(actual_moves).standard_ll_code, urot: Cube.new(actual_moves).standard_ll_code_offset}
  rescue Exception => e
    render json: { error: e.message }
  end


  def store_parameters(cookie_name, defaults, new_data = params)
    stored_parameters = defaults.keys
    if new_data.has_key?(stored_parameters.first)
      values = {}
      stored_parameters.each { |k| values[k] = new_data[k] || defaults[k] }
      cookies[cookie_name] = JSON.generate(values)
    else
      values = cookies[cookie_name] ? JSON.parse(cookies[cookie_name], symbolize_names: true) : defaults # TODO handle bad cookie
    end
    values
  end

  def vc
    view_context
  end
end