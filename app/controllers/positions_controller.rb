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

    take_prefs_from_params = (params.keys.map(&:to_sym) & Fields::ALL_DEFAULTS.keys).present? || !params[:udf].nil?
    if take_prefs_from_params
      PositionsController.store_list_format(cookies, params)
    end
    @list_format = PositionsController.read_list_format(cookies)

    @algs_mode = (@list_format.list == 'algs') || @filters.count == PosFilters::BASE.count

    query_includes = @algs_mode ? :stats : [:stats, :best_alg]
    @positions = Position.where(@filters.where).order(:optimal_alg_length, :cop, :eo, :ep).includes(query_includes).to_a
    @position_ids = @positions.map(&:id)
    @only_position = @positions.first if @filters.count == PosFilters::BASE.count
    @setup_alg = Algs.reverse(Algs.shift(@positions.first.best_alg.moves, @positions.first.pov_offset)) if @filters.count >= 2
    @pos_name = @only_position&.nick_name

    @stats = stats_for_view(@only_position)

    @selected_icons, @icon_grids = {}, {}
    PosFilters::ALL.each do |f|
      icons = Icons::Base.class_by(f)
      @selected_icons[f] = icons.by_code(@filters[f])
      @icon_grids[f] = icons::grid(subset: @position_set, cp: @filters[:cp])
    end

    @list_items =
        if @algs_mode
          alg_set = AlgSet.find_by_id(@list_format.algset.to_i)
          @combo_mode = PREFS.use_combo_set && @only_position && alg_set && (@only_position.eo == '4' || alg_set.subset == 'all')
          if @combo_mode
            raw_algs = @only_position.algs_in_set(alg_set, sortby: @list_format.sortby, limit: @list_format.lines.to_i)
            raw_algs.map { |alg| [alg] + alg.combo_algs_in(alg_set) }.reduce(:+)
          else
            RawAlg.where(position_id: @positions.map(&:main_position_id)).includes(:position).order(@list_format.sortby).limit(@list_format.lines.to_i).to_a
          end
        else
          limit = 100
          if @positions.count > limit
            @clipped = {shown: limit, total: @positions.count}
          end
          @positions.first(limit)
        end
    @list_items ||= []

    @text_size = cookies[:size] || 'm'
    @list_classes = PositionsController.table_class(@algs_mode, @combo_mode, @text_size, @selected_icons)

    @rendered_svg_ids = Set.new
    @columns = @algs_mode ? make_alg_columns : make_pos_columns
    @page_rotation = (params[:prot] || 0).to_i

    if params[:hl_alg]
      @hi_lite = params[:hl_alg]
      @list_items.insert(0, DuckRawAlg.new(Algs.shift(@hi_lite, -@page_rotation)))
    end
    if params[:hl_id]
      @hi_lite = params[:hl_id].to_i
      @list_items += [RawAlg.find(params[:hl_id].to_i)] unless @list_items.map(&:id).include?(@hi_lite)
    end
  end

  def make_alg_columns
    columns = [Column::SPEED, Column::LENGTH].rotate(@list_format.sortby == '_speed' ? 0 : 1)
    columns << Column::NAME
    columns << Column::POSITION unless @only_position
    columns << Column::COP if @selected_icons[:cop].is_none
    columns << Column::EO  if @selected_icons[:eo].is_none
    columns << Column::EP  if @selected_icons[:ep].is_none
    columns << Column::STARS
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
    fully_populated_lengths = data.raw_counts.keys.reject{ |len| len > RawAlg::DB_COMPLETENESS_LENGTH }.sort
    result.sections << fully_populated_lengths.map do |length|
      count = data.raw_counts[length]
      OpenStruct.new(label: "#{length} moves", text: vc.spaced_number(count) + ' alg' + (count == 1 ? '' : 's'))
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

  def self.store_list_format(the_cookies, new_prefs)
    values = {}
    Fields::ALL.each { |field| values[field.name] = field.value(new_prefs) if new_prefs.keys.map(&:to_sym).include?(field.name) }
    the_cookies.permanent[Fields::COOKIE_NAME] = JSON.generate(values)
  end

  def self.read_list_format(the_cookies)
    from_cookies = the_cookies[Fields::COOKIE_NAME] ? JSON.parse(the_cookies[:field_values], symbolize_names: true) : {}
    OpenStruct.new(Fields.values(from_cookies))
  rescue
    OpenStruct.new(Fields::ALL_DEFAULTS)
  end

  def self.bookmark_url(filters, all_params)
    tail = all_params.except(:pos, :poschange).to_query
    "?pos=#{filters.pos_code}" + (tail.present? ? '&' + tail : '')
  end

  def self.table_class(algs_mode, combo_mode, size, selected_icons)
    base = algs_mode ? 'algs-list' : 'positions-list'
    base += ' combo-list' if combo_mode
    has_icons = selected_icons[:cop].is_none || selected_icons[:eo].is_none || selected_icons[:ep].is_none
    with_icons = (has_icons ? '-wc' : '')
    "#{base} size-#{size}#{with_icons}"
  end

  def vc # access helpers
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
    user_prefs = PositionsController.read_list_format(params).to_h
    user_prefs.reject {|k,v| Fields::ALL_DEFAULTS[k] == v }
  end

  # === Routed action ===
  def find_by_alg
    user_input = params[:alg].upcase.gsub(/[\+\(\)]/, ' ').gsub("2'", "2").strip
    moves = user_input.split(' ')
    while moves.last[0] == 'U' do moves.pop end
    user_input = moves.join(' ')

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

# TODO Got to get rid of these Ducks...
class DuckPosition
  def pov_offset
    0
  end

  def pov_adjust_u_setup
    0
  end

  def pov_variant_in(selected_ids)
    self
  end
end

class DuckRawAlg
  attr_reader :moves, :length, :speed, :name, :u_setup, :specialness, :nick_name

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
    DuckPosition.new
  end

  def pov_variant_in(ignore)
    position
  end

  def matches(search_term)
    true
  end

  def single?
    true
  end
end
