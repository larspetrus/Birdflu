class PositionsController < ApplicationController

  def index
    @filters = PosSubsets.compute_filters(params)
    return redirect_to "/?" + Fields::FILTER_NAMES.map{|k| "#{k}=#{@filters[k]}"}.join('&') if @filters[:_reload]

    @single_position = @filters[:cop].present? && @filters[:eo].present? && @filters[:ep].present?

    format_params = store_parameters(:format, Fields.defaults(Fields::FORMATS))
    @format = OpenStruct.new(
        list:   Fields::LIST.value(format_params),
        lines:  Fields::LINES.value(format_params),
        sortby: Fields::SORTBY.value(format_params),
    )
    @list_algs =  @format.list == 'algs' || @single_position

    includes = @list_algs ? :stats : [:stats, :best_alg]
    @positions = Position.where(@filters.select{|k,v| v.present?}).order(:optimal_alg_length).includes(includes).to_a
    @single_position = @positions.first if @single_position # Now we know which position

    @stats = stats_for_view(@single_position)

    @selected_icons = {}
    Fields::FILTER_NAMES.each{ |f| @selected_icons[f] = Icons::Base.by_code(f, @filters[f]) }

    @icon_grids = {}
    Fields::FILTER_NAMES.each{ |f| @icon_grids[f] = Icons::Base.class_by(f)::grid  unless f == :ep }
    @icon_grids[:ep] = Icons::Ep.grid_for(@filters[:cp])

    @list_items =
        @list_algs ?
          RawAlg.where(position_id: @positions.map(&:id)).includes(:position).order(@format.sortby).limit(@format.lines.to_i) :
          @positions.first(100)

    @svg_ids = Set.new
    @columns = @list_algs ? make_alg_columns : make_pos_columns
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
      OpenStruct.new(label: "#{length} moves", text: "#{view_context.pluralize(data.raw_counts[length], 'alg')}")
    end

    if single_pos
      result.headline = "Position #{single_pos.display_name}"
      result.link_section = [
          single_pos.has_mirror  ? view_context.link_to("Mirror - #{single_pos.mirror.display_name}",  "positions/#{single_pos.mirror_id}")  : "No mirror",
          single_pos.has_inverse ? view_context.link_to("Inverse - #{single_pos.inverse.display_name}","positions/#{single_pos.inverse_id}") : "No inverse",
      ]
    else
      result.headline = "#{data.position_count} positions"

      optimal_sum = @positions.reduce(0.0) { |sum, pos| sum + (pos.optimal_alg_length || 100)}
      result.sections[0] << OpenStruct.new(label: "Avg shortest", text: '%.2f' % (optimal_sum/@positions.count))
    end
    result
  end

  def show
    pos = Position.find_by_id(params[:id]) || Position.by_ll_code(params[:id]) || RawAlg.find_by_alg_id(params[:id]).position # Try DB id LL code, or alg name
    redirect_to "/?" + Fields::FILTER_NAMES.map{|k| "#{k}=#{pos[k]}"}.join('&')
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
      values = {}
      stored_parameters.each { |k| values[k] = new_data[k] || defaults[k] }
      cookies[cookie_name] = JSON.generate(values)
    else
      values = cookies[cookie_name] ? JSON.parse(cookies[cookie_name], symbolize_names: true) : defaults # TODO handle bad cookie
    end
    values
  end
end