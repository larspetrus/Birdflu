# frozen_string_literal: true

class PositionsController < ApplicationController

  def index  # === Routed action ===
    get_prefs_from_params = (params.keys.map(&:to_sym) & Fields::ALL_DEFAULTS.keys).present? || !params[:udf].nil?

    # Show a random concrete position, if you seem to be a newbie.
    if cookies[Fields::COOKIE_NAME].blank? && params[:pos].blank? && !get_prefs_from_params
      redirect_to "/?pos=#{Position.random_name}&rnd=t" and return
    end

    Fields.store_list_def(cookies, params) if get_prefs_from_params

    setup_leftbar

    flash.now[:notification] = "Random position" if params[:rnd]
    @filters = PosFilters.new(params, @position_set)
    @bookmark_url = PositionsController.bookmark_url(@filters, request.query_parameters).html_safe

    @algs_mode = (@list_format.list == 'algs') || @filters.count == PosFilters::BASE.count

    query_includes = @algs_mode ? :stats : [:stats, :best_alg]
    @positions = Position.where(@filters.where).order(:optimal_alg_length, :cop, :eo, :ep).includes(query_includes).to_a
    @position_ids = @positions.map(&:id)
    @only_position = @positions.first if @filters.count == PosFilters::BASE.count
    @setup_alg = Algs.reverse(Algs.shift(@positions.first.best_alg.moves, @positions.first.pov_offset)) if @filters.count >= 2
    @pos_name = @only_position&.nick_name

    @stats = stats_for_view(@only_position)

    @picked, @icon_grids = {}, {}
    PosFilters::ALL.each do |f|
      icons = Icons::Base.class_by(f)
      @picked[f] = icons.by_code(@filters[f])
      @icon_grids[f] = icons::grid(subset: @position_set, cp: @filters[:cp])
    end

    combos_in_list = false
    @list_items =
        if @algs_mode
          alg_set = AlgSet.find_by_id(@list_format.algset.to_i) # works even when id not in DB

          raw_algs = combo_raw_algs = []
          combos_allowed = @only_position && alg_set.present? && alg_set.applies_to(@only_position)

          if (@list_format.combos != 'none') && combos_allowed
            combo_raw_algs = @only_position.algs_in_set(alg_set, sortby: @list_format.sortby, limit: @list_format.lines)
            flash.now[:notification] = "No Combo algs found" if combo_raw_algs.empty?
          end

          if @list_format.combos != 'only' || combo_raw_algs.empty?
            raw_algs = RawAlg.where(position_id: @positions.map(&:main_position_id))
                           .includes(:position).order(@list_format.sortby).limit(@list_format.lines.to_i).to_a
          end

          combos_in_list = combo_raw_algs.present?
          case ((raw_algs.present? ? 1 : 0) + (combo_raw_algs.present? ? 2 : 0))
            when 0 # make sure we have a list
              []
            when 1 #'none'
              raw_algs
            when 2 #'only'
              combo_raw_algs.map { |alg| [alg] + alg.combo_algs_in(alg_set) }.flatten
            when 3 #'merge'
              raw_alg_ids = Set.new(raw_algs.map(&:id))
              raw_algs += combo_raw_algs.reject{|cra| raw_alg_ids.include?(cra.id) }

              has_combos = Set.new(combo_raw_algs.map(&:id))
              raw_algs.map { |alg| [alg] + (has_combos.include?(alg.id) ? alg.combo_algs_in(alg_set) : []) }.flatten
          end
        else
          limit = 100
          if @positions.count > limit
            @clipped = {shown: limit, total: @positions.count}
          end
          @positions.first(limit)
        end

    if @login && @algs_mode
      @stars_by_alg = {}
      @stars_by_alg['raw_alg'] = Galaxy.star_styles_by_alg(@login.db_id, @list_items.map(&:id), 'raw_alg')
      @stars_by_alg['combo_alg'] = Galaxy.star_styles_by_alg(@login.db_id, @list_items.map(&:id), 'combo_alg')
    end
    @table_context = OpenStruct.new(stats: @stats.data, possible_pos_ids: @position_ids, login: @login, stars: @stars_by_alg)

    @list_classes = table_class(@algs_mode, combos_in_list, @text_size, @picked, @login)

    @columns = @algs_mode ? make_alg_columns : make_pos_columns
    @page_rotation = (params[:prot] || 0).to_i

    if params[:hl_alg]
      @list_items.insert(0, RawAlg.make_non_db(Algs.shift(Algs.unpack(params[:hl_alg]), -@page_rotation)))
    end
    if params[:hl_id]
      if params[:hl_id].start_with?('c') # combo alg?
        @hi_lite_id = params[:hl_id]
      else
        @hi_lite_id = params[:hl_id].to_i
        @list_items += [RawAlg.find(@hi_lite_id)] unless @list_items.map(&:id).include?(@hi_lite_id)
      end
    end
    use_svgs
  end

  def make_alg_columns
    start = [:speed, :length].rotate(@list_format.sortby == '_speed' ? 0 : 1)
    start << :name
    start << :position unless @only_position
    Column.named(start + icon_columns + [:alg, :show, :notes, :stars])
  end

  def make_pos_columns
    Column.named([:position] + icon_columns + [:length_p, :alg_p, :show])
  end

  def icon_columns
    [:cop, :eo, :ep].select{|col| @picked[col].is_none }
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
      result.headline = "Position #{single_pos.display_name}"

      rotation_links = single_pos.pov_rotations.map { |id| pos_link(Position.find(id)) }
      s = (rotation_links.count == 1 ? '' : 's')

      result.link_section = [
          { label: 'Mirror',  links: single_pos.has_mirror  ? [pos_link(single_pos.mirror)]   : ['None'] },
          { label: 'Inverse', links: single_pos.has_inverse ? [pos_link(single_pos.inverse)]  : ['None'] },
          rotation_links.present? ? { label: 'Rotation'+s, links: rotation_links} : nil
      ].compact
    else
      result.headline = "#{data.position_count} positions"

      optimal_sum = @positions.reduce(0.0) { |sum, pos| sum + (pos.optimal_alg_length || 100)}
      result.sections[0] << OpenStruct.new(label: "Avg shortest", text: '%.2f' % (optimal_sum/@positions.count))
    end
    result
  end

  def pos_link(pos)
    vc.link_to(pos.display_name,  "/?pos=#{pos.display_name}")
  end

  def self.bookmark_url(filters, all_params)
    tail = all_params.except(:pos, :poschange, :rnd).as_json.to_query
    "?pos=#{filters.pos_code}" + (tail.present? ? '&' + tail : '')
  end

  def table_class(algs_mode, combo_mode, size, picked, login)
    classes = [algs_mode ? 'algs-list' : 'positions-list']
    classes << 'combo-list' if combo_mode
    classes << 'algs-loggedout' unless login || !algs_mode
    has_icons = picked[:cop].is_none || picked[:eo].is_none || picked[:ep].is_none
    with_icons = (has_icons ? '-wc' : '')
    classes << "size-#{size}#{with_icons}"
    classes.join(' ')
  end

  def vc # access helpers
    view_context
  end

  def show  # === Routed action ===
    pos = Position.find_by_id(params[:id]) || Position.by_ll_code(params[:id]) || RawAlg.by_name(params[:id]).position # Try DB id LL code, or alg name

    new_params = { pos: pos.display_name }

    new_params[:hl_id] = params[:hl_id]                if params[:hl_id]
    new_params[:hl_id] ||= RawAlg.id(params[:hl_name]) if params[:hl_name]
    new_params[:hl_alg] = params[:hl_alg]              if params[:hl_alg]

    new_params[:prot] = params[:prot] if %w(1 2 3).include?(params[:prot])

    as_query = []
    new_params.merge!(non_default_fields).each{ |k,v| as_query << "#{k}=#{v}"}
    redirect_to "/?" + as_query.join('&')
  end

  def non_default_fields
    list_format_definition = Fields.read_list_def(params).to_h
    list_format_definition.reject {|k,v| Fields::ALL_DEFAULTS[k] == v }
  end

  def find_by_alg  # === Routed action ===
    moves = params[:post_alg].strip.split(' ')
    while moves.last[0] == 'U' do moves.pop end
    cleaned_input = moves.join(' ')

    if cleaned_input.include? ' ' # interpret as moves
      actual_moves = cleaned_input
      ll_code = Cube.by_alg(actual_moves).standard_ll_code # raises exception unless alg is good

      found_alg = RawAlg.with_moves(cleaned_input, Position.find_by!(ll_code: ll_code))
    else # interpret as alg name
      found_alg = RawAlg.by_name(cleaned_input)
      raise "There is no alg named '#{cleaned_input}'" unless found_alg
      actual_moves = found_alg.moves
    end

    result = { ll_code: Cube.by_alg(actual_moves).standard_ll_code, prot: Cube.by_alg(actual_moves).standard_ll_code_offset}
    if found_alg
      result[:alg_id] = found_alg.id
    else
      result[:packed_alg] = Algs.pack(cleaned_input)
    end
    render json: result
  rescue Exception => e
    render json: { error: e.message }
  end
end
