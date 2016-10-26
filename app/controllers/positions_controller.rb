# frozen_string_literal: true

class PositionsController < ApplicationController

  PREFS = OpenStruct.new(
      use_combo_set: Rails.env.development?,
  )

  # === Routed action ===
  def index
    @position_set = cookies[:zbll] ?  'eo' : 'all'
    @filters = PosFilters.new(params, @position_set)
    @bookmark_url = PositionsController.bookmark_url(@filters, request.query_parameters)

    take_prefs_from_params = (params.keys.map(&:to_sym) & Fields::ALL_DEFAULTS.keys).present? || params[:udf].present?
    if take_prefs_from_params
      PositionsController.store_user_prefs(cookies, params)
    end
    @user_prefs = PositionsController.read_user_prefs(cookies)

    @algs_mode = (@user_prefs.list == 'algs') || @filters.all_set

    query_includes = @algs_mode ? :stats : [:stats, :best_alg]
    @positions = Position.where(@filters.where).order(:optimal_alg_length, :cop, :eo, :ep).includes(query_includes).to_a
    @position_ids = @positions.map(&:id)
    @only_position = @positions.first if @filters.all_set

    @stats = stats_for_view(@only_position)

    @selected_icons, @icon_grids = {}, {}
    PosFilters::ALL.each do |f|
      icons = Icons::Base.class_by(f)
      @selected_icons[f] = icons.by_code(@filters[f])
      @icon_grids[f] = icons::grid(subset: @position_set, cp: @filters[:cp])
    end

    @list_classes = PositionsController.table_class(@algs_mode, 'm', @selected_icons)

    @list_items =
        if @algs_mode
          if PREFS.use_combo_set && @only_position && alg_set = AlgSet.find_by_id(@user_prefs.algset.to_i)
            raw_algs = @only_position.algs_in_set(alg_set, sortby: @user_prefs.sortby, limit: @user_prefs.lines.to_i)
            raw_algs.map { |alg| [alg] + alg.combo_algs_in(alg_set) }.reduce(:+)
          else
            RawAlg.where(position_id: @positions.map(&:main_position_id)).includes(:position).order(@user_prefs.sortby).limit(@user_prefs.lines.to_i).to_a
          end
        else
          limit = 100
          if @positions.count > limit
            @clipped = {shown: limit, total: @positions.count}
          end
          @positions.first(limit)
        end

    @rendered_svg_ids = Set.new
    @columns = @algs_mode ? make_alg_columns : make_pos_columns
    @page_rotation = (params[:prot] || 0).to_i

    if params[:hl_alg]
      @hi_lite = params[:hl_alg]
      @list_items += [DuckRawAlg.new(Algs.shift(@hi_lite, -@page_rotation))]
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
    columns = [Column::SPEED, Column::LENGTH].rotate(@user_prefs.sortby == '_speed' ? 0 : 1)
    columns << Column::NAME
    columns << Column::POSITION unless @only_position
    columns << Column::COP if @selected_icons[:cop].is_none
    columns << Column::EO  if @selected_icons[:eo].is_none
    columns << Column::EP  if @selected_icons[:ep].is_none
    columns << Column::ALG << Column::SHOW << Column::NOTES
  end

  def make_pos_columns
    columns = [Column::POSITION]
    columns << Column::COP if @selected_icons[:cop].is_none
    columns << Column::EO  if @selected_icons[:eo].is_none
    columns << Column::EP  if @selected_icons[:ep].is_none
    columns << Column::LENGTH_P << Column::ALG_P << Column::SHOW
  end

  def stats_for_view(single_pos)
    data = PositionStats.aggregate(@positions)
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
          { label: 'Mirror',  links: single_pos.has_mirror  ? [pos_link(single_pos.mirror)]   : ['None'] },
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

  def self.store_user_prefs(the_cookies, new_prefs)
    values = {}
    Fields::ALL.each { |field| values[field.name] = field.value(new_prefs) if new_prefs.keys.map(&:to_sym).include?(field.name) }
    the_cookies.permanent[Fields::COOKIE_NAME] = JSON.generate(values)
  end

  def self.read_user_prefs(the_cookies)
    from_cookies = the_cookies[Fields::COOKIE_NAME] ? JSON.parse(the_cookies[:field_values], symbolize_names: true) : {}
    OpenStruct.new(Fields.values(from_cookies))
  rescue
    OpenStruct.new(Fields::ALL_DEFAULTS)
  end

  def self.bookmark_url(filters, all_params)
    tail = all_params.except(:pos, :poschange).to_query
    "?pos=#{filters.pos_code}" + (tail.present? ? '&' + tail : '')
  end

  def self.table_class(algs_mode, size, selected_icons)
    base = algs_mode ? 'algs-list' : 'positions-list'
    has_cubes = selected_icons[:cop].is_none || selected_icons[:eo].is_none || selected_icons[:ep].is_none
    with_cubes = (has_cubes ? '-wc' : '')
    "#{base} size-#{size}#{with_cubes}"
  end

  def vc
    view_context
  end

  # === Routed action ===
  def show
    pos = Position.find_by_id(params[:id]) || Position.by_ll_code(params[:id]) || RawAlg.by_name(params[:id]).position # Try DB id LL code, or alg name

    new_params = { pos: pos.display_name }

    new_params[:hl_id] = params[:hl_id]                if params[:hl_id]
    new_params[:hl_id] ||= RawAlg.id(params[:hl_name]) if params[:hl_name]
    new_params[:hl_alg] = params[:hl_alg]              if params[:hl_alg]

    new_params[:prot] = params[:prot] if ['1', '2', '3'].include?(params[:prot])

    as_query = []
    new_params.merge!(non_default_fields).each{ |k,v| as_query << "#{k}=#{v}"}
    redirect_to "/?" + as_query.join('&')
  end

  def non_default_fields
    user_prefs = PositionsController.read_user_prefs(params).to_h
    user_prefs.reject {|k,v| Fields::ALL_DEFAULTS[k] == v }
  end

  # === Routed action ===
  def find_by_alg
    user_input = params[:alg].upcase.strip

    if user_input.include? ' ' # interpret as moves
      actual_moves = user_input
      ll_code = Cube.new(actual_moves).standard_ll_code # raises exception unless alg is good

      db_alg = RawAlg.find_from_moves(user_input, Position.find_by!(ll_code: ll_code))
    else # interpret as alg name
      db_alg = RawAlg.by_name(user_input)
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
  attr_reader :moves, :length, :speed, :name, :u_setup, :specialness

  def initialize(moves)
    @moves = moves
    @length  = Algs.length(moves)
    @speed   = Algs.speed_score(moves)
    @u_setup = Algs.standard_u_setup(moves)

    @name = '-'
    @specialness = 'Not in DB'
  end

  def presenter(context)
    RawAlgColumns.new(self, context)
  end

  def position
    OpenStruct.new(pov_offset: 0, pov_adjust_u_setup: 0)
  end

  def matches(search_term)
    true
  end

  def single?
    true
  end
end
