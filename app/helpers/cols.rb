# frozen_string_literal: true

# The
#
# As a "view presenter" class, it makes sense to me to put this in the View helpers directory. DHH may disagree.

class Cols
  attr_reader :is_svg, :svg_config, :header

  def initialize(header, content, svg_config = nil)
    @header = header
    @content = content
    @is_svg = svg_config.present?
    @svg_config = svg_config
  end

  def with_header(new_header)
    Cols.new(new_header, @content, @svg_config)
  end

  MOVES = Cols.new('Moves', -> (view_item, flags) { view_item.moves(flags) })
  MOVES_P = MOVES.with_header('')

  SPEED = Cols.new('Speed', -> (view_item, flags) { view_item.speed(flags) })
  NAME  = Cols.new('Name', -> (view_item, flags) { view_item.name(flags) })
  COP   = Cols.new('COP', nil, -> (view_item, flags) { view_item.cop(flags) } )
  EO    = Cols.new('EO',  nil, -> (view_item, flags) { view_item.eo(flags) } )
  EP    = Cols.new('EP',  nil, -> (view_item, flags) { view_item.ep(flags) } )

  POSITION = Cols.new('Position', -> (view_item, flags) { view_item.position(flags) })
  ALG      = Cols.new('Alg', -> (view_item, flags) { view_item.alg(flags) })
  ALG_P = ALG.with_header('Shortest Solution')

  SHOW = Cols.new('', -> (view_item, flags) { view_item.show(flags) })
  NOTES = Cols.new('Notes', -> (view_item, flags) { view_item.notes(flags) })
  SOLUTIONS = Cols.new('Solutions', -> (view_item, flags) { view_item.solutions(flags) })

  def td(alg, flags)
    @content.call(alg, flags)
  end

  def self.h
    ActionController::Base.helpers
  end

  def self.td_tag(content, options = nil)
    h.content_tag(:td, content, options)
  end

  def self.tag(type, content, css_class = nil)
    h.content_tag(type, content, class: css_class)
  end

  def self.highlight(optimal, copy)
    return nil unless optimal || copy
    (optimal ? 'optimal' : '') + (copy ? 'copy' : '')
  end

  def self.as_pos(alg_or_pos, flags)
    alg_or_pos.respond_to?(:position) ? alg_or_pos.position.pov_variant_in(flags[:selected_pos_ids]) : alg_or_pos
  end

  def self.as_alg(alg_or_pos)
    alg_or_pos.respond_to?(:best_alg) ? (alg_or_pos.best_alg || OpenStruct.new) : alg_or_pos
  end

  def self.adapter(list_item)
    return AdaptRaw.new(list_item)   if list_item.class == RawAlg
    return AdaptCombo.new(list_item) if list_item.class == ComboAlg
    return AdaptPos.new(list_item)   if list_item.class == Position
    raise "Unknown list item class #{list_item.class}"
  end
end



class AdaptPos
  def initialize(position, adapt_raw = nil)
    @position = position
    @adapt_raw = adapt_raw
  end

  def as_raw
    @adapt_raw ||= AdaptRaw.new(@position.best_alg)
  end

  def alg(flags)
    as_raw.alg(flags)
  end

  def speed(flags)
    as_raw.speed(flags)
  end

  def moves(flags)
    as_raw.moves(flags)
  end

  def show(flags)
    as_raw.show(flags)
  end

  def position(flags)
    Cols.tag(:td, Cols.h.link_to(@position.display_name, "/positions/#{@position.ll_code}"))
  end

  def cop(flags)
    { icon: Icons::Cop.for(@position), size: 22, label: ''}
  end

  def eo(flags)
    {icon: Icons::Eo.for(@position), size: 22, label: ''}
  end

  def ep(flags)
    {icon: Icons::Ep.for(@position), size: 22, label: ''}
  end

  def solutions(flags)
    Cols.tag(:td, @position.alg_count)
  end
end


class AdaptRaw
  def initialize(raw_alg, adapt_pos = nil)
    @raw_alg = raw_alg
    @adapt_pos = adapt_pos
  end

  def as_pos
    @adapt_pos ||= AdaptPos.new(@raw_alg.position, self)
  end


  def alg(flags)
    Cols.tag(:td, Algs.shift(@raw_alg.moves, @raw_alg.position.pov_offset), 'alg')
  end

  def speed(flags)
    Cols.tag(:td, '%.2f' % @raw_alg.speed, Cols.highlight(flags[:fastest], flags[:copy]))
  end

  def moves(flags)
    Cols.tag(:td, @raw_alg.length, Cols.highlight(flags[:shortest], flags[:copy]))
  end

  def name(flags)
    Cols.tag(:td, @raw_alg.name, 'single')
  end

  def show(flags)
    pov_adjust = @raw_alg.position.pov_adjust_u_setup
    Cols.td_tag(Cols.tag(:a, 'show', 'show-pig'), :'data-uset' => (@raw_alg.u_setup + pov_adjust) % 4 )
  end

  def notes(flags)
    Cols.tag(:td, @raw_alg.specialness)
  end

  def position(flags)
    as_pos.position(flags)
  end

  def cop(flags)
    as_pos.cop(flags)
  end

  def eo(flags)
    as_pos.eo(flags)
  end

  def ep(flags)
    as_pos.ep(flags)
  end

end


class AdaptCombo
  def initialize(combo_alg)
    @combo_alg = combo_alg
  end

  def alg(flags)
    result = ''.html_safe
    @combo_alg.recon.each { |part| result += Cols.tag(:span, part[0], part[1]) }
    Cols.tag(:td, result)
  end

  def speed(flags)
    Cols.tag(:td, '')
  end

  def moves(flags)
    Cols.tag(:td, '')
  end

  def name(flags)
    Cols.tag(:td, Cols.tag(:span, @combo_alg.alg1.name, 'goto-pos') + '+' + Cols.tag(:span, @combo_alg.alg2.name, 'goto-pos'), 'combo')
  end

  def show(flags)
    Cols.tag(:td, '')
  end

  def notes(flags)
    Cols.tag(:td, '')
  end

  def position(flags)
    Cols.tag(:td, '')
  end

  def cop(flags)
    {icon: Icons::Cop.for(Position.find(22)), size: 22, label: ''}
  end

  def eo(flags)
    {icon: Icons::Cop.for(Position.find(22)), size: 22, label: ''}
  end

  def ep(flags)
    {icon: Icons::Cop.for(Position.find(22)), size: 22, label: ''}
  end

end