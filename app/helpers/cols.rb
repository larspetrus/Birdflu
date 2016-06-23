# frozen_string_literal: true

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

  MOVES = Cols.new('Moves', -> (presenter) { presenter.moves })
  MOVES_P = MOVES.with_header('')

  SPEED = Cols.new('Speed', -> (presenter) { presenter.speed })
  NAME  = Cols.new('Name', -> (presenter) { presenter.name })
  COP   = Cols.new('COP', nil, -> (presenter) { presenter.cop } )
  EO    = Cols.new('EO',  nil, -> (presenter) { presenter.eo } )
  EP    = Cols.new('EP',  nil, -> (presenter) { presenter.ep } )

  POSITION = Cols.new('Position', -> (presenter) { presenter.position })
  ALG      = Cols.new('Alg', -> (presenter) { presenter.alg })
  ALG_P = ALG.with_header('Shortest Solution')

  SHOW = Cols.new('', -> (presenter) { presenter.show })
  NOTES = Cols.new('Notes', -> (presenter) { presenter.notes })
  SOLUTIONS = Cols.new('Solutions', -> (presenter) { presenter.solutions })

  def cell(alg)
    @content.call(alg)
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

  def self.as_pos(alg_or_pos, flags)
    alg_or_pos.respond_to?(:position) ? alg_or_pos.position.pov_variant_in(flags[:selected_pos_ids]) : alg_or_pos
  end

  def self.as_alg(alg_or_pos)
    alg_or_pos.respond_to?(:best_alg) ? (alg_or_pos.best_alg || OpenStruct.new) : alg_or_pos
  end
end



class PositionColumns
  delegate :alg, :speed, :moves, :show, :to => :raw_cols

  def initialize(position, context, raw_cols = nil)
    @position = position
    @context = context
    @raw_cols = raw_cols
  end

  def raw_cols
    @raw_cols ||= RawAlgColumns.new(@position.best_alg, @context, self)
  end

  def position
    Cols.tag(:td, Cols.h.link_to(@position.display_name, "/positions/#{@position.ll_code}"))
  end

  def cop
    { icon: Icons::Cop.for(@position), size: 22, label: ''}
  end

  def eo
    {icon: Icons::Eo.for(@position), size: 22, label: ''}
  end

  def ep
    {icon: Icons::Ep.for(@position), size: 22, label: ''}
  end

  def solutions
    Cols.tag(:td, @position.alg_count)
  end
end


class RawAlgColumns
  delegate :cop, :eo, :ep, :position, :to => :pos_cols

  def initialize(raw_alg, context, pos_cols = nil)
    @raw_alg = raw_alg
    @context = context
    @pos_cols = pos_cols
  end

  def pos_cols
    @pos_cols ||= PositionColumns.new(@raw_alg.position, self)
  end


  def alg
    Cols.tag(:td, Algs.shift(@raw_alg.moves, @raw_alg.position.pov_offset), 'alg')
  end

  def speed
    Cols.tag(:td, '%.2f' % @raw_alg.speed, @raw_alg.speed == @context[:stats]&.fastest ? 'optimal' : '')
  end

  def moves
    Cols.tag(:td, @raw_alg.length, @raw_alg.length == @context[:stats]&.shortest ? 'optimal' : '')
  end

  def name
    Cols.tag(:td, @raw_alg.name, 'single')
  end

  def show
    pov_adjust = @raw_alg.position.pov_adjust_u_setup
    Cols.td_tag(Cols.tag(:a, 'show', 'show-pig'), :'data-uset' => (@raw_alg.u_setup + pov_adjust) % 4 )
  end

  def notes
    Cols.tag(:td, @raw_alg.specialness)
  end
end


class ComboAlgColumns
  attr_reader :speed, :moves, :show, :notes, :position, :cop, :eo, :ep

  def initialize(combo_alg, context)
    @combo_alg = combo_alg
    @context = context

    @speed = @moves = @show = @notes = @position = Cols.tag(:td, '')
    @cop = @eo = @ep = nil
  end

  def alg
    result = ''.html_safe
    @combo_alg.recon.each { |part| result += Cols.tag(:span, part[0], part[1]) }
    Cols.tag(:td, result)
  end

  def name
    Cols.tag(:td, Cols.tag(:span, @combo_alg.alg1.name, 'goto-pos') + '+' + Cols.tag(:span, @combo_alg.alg2.name, 'goto-pos'), 'combo')
  end
end