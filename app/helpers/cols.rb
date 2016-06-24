# frozen_string_literal: true

# "View presenter" code for the alg/position list/table.

class Cols
  attr_reader :is_svg, :svg_config, :header

  def initialize(header, method, is_svg: false)
    @header = header
    @method = method
    @is_svg = is_svg
  end

  MOVES    = Cols.new('Moves', :moves)
  MOVES_P  = Cols.new('', :moves)
  SPEED    = Cols.new('Speed', :speed)
  NAME     = Cols.new('Name', :name)
  POSITION = Cols.new('Position', :position)
  ALG      = Cols.new('Alg', :alg)
  ALG_P    = Cols.new('Shortest Solution', :alg)
  SHOW     = Cols.new('', :show)
  NOTES    = Cols.new('Notes', :notes)

  COP = Cols.new('COP', :cop, is_svg: true )
  EO  = Cols.new('EO',  :eo,  is_svg: true )
  EP  = Cols.new('EP',  :ep,  is_svg: true )

  def cell(presenter)
    presenter.send(@method)
  end

  def svg_params(presenter)
    presenter.send(@method)
  end

  def self.as_pos(alg_or_pos, flags)
    alg_or_pos.respond_to?(:position) ? alg_or_pos.position.pov_variant_in(flags[:selected_pos_ids]) : alg_or_pos
  end

  def self.as_alg(alg_or_pos)
    alg_or_pos.respond_to?(:best_alg) ? (alg_or_pos.best_alg || OpenStruct.new) : alg_or_pos
  end
end


def hlp
  ActionController::Base.helpers
end

def td_tag(content, options = nil)
  hlp.content_tag(:td, content, options)
end

def tag(type, content, css_class = nil)
  hlp.content_tag(type, content, class: css_class)
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
    tag(:td, hlp.link_to(@position.display_name, "/positions/#{@position.ll_code}"))
  end

  def cop
    { icon: Icons::Cop.for(@position), size: 22, label: ''}
  end

  def eo
    { icon: Icons::Eo.for(@position), size: 22, label: ''}
  end

  def ep
    { icon: Icons::Ep.for(@position), size: 22, label: ''}
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
    tag(:td, Algs.shift(@raw_alg.moves, @raw_alg.position.pov_offset), 'js-alg')
  end

  def speed
    tag(:td, '%.2f' % @raw_alg.speed, @raw_alg.speed == @context[:stats]&.fastest ? 'optimal' : '')
  end

  def moves
    tag(:td, @raw_alg.length, @raw_alg.length == @context[:stats]&.shortest ? 'optimal' : '')
  end

  def name
    tag(:td, @raw_alg.name, 'single')
  end

  def show
    pov_adjust = @raw_alg.position.pov_adjust_u_setup
    td_tag(tag(:a, 'show', 'show-pig'), :'data-uset' => (@raw_alg.u_setup + pov_adjust) % 4 )
  end

  def notes
    tag(:td, @raw_alg.specialness)
  end
end


class ComboAlgColumns
  attr_reader :speed, :moves, :show, :notes, :position, :cop, :eo, :ep

  def initialize(combo_alg, context)
    @combo_alg = combo_alg
    @context = context

    @speed = @moves = @show = @notes = @position = tag(:td, '')
    @cop = @eo = @ep = nil
  end

  def alg
    result = ''.html_safe
    @combo_alg.recon.each { |part| result += tag(:span, part[0], part[1]) }
    tag(:td, result, 'js-combo')
  end

  def name
    tag(:td, tag(:span, @combo_alg.alg1.name, 'js-goto-post') + '+' + tag(:span, @combo_alg.alg2.name, 'js-goto-post'), 'combo')
  end
end