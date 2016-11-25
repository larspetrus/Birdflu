# frozen_string_literal: true

# "View presenter" code for the alg/position list/table columns.

class Column
  attr_reader :is_svg, :svg_config, :header

  def initialize(header, method, is_svg: false)
    @header = header
    @method = method
    @is_svg = is_svg
  end

  LENGTH   = self.new('Moves', :moves)
  LENGTH_P = self.new('', :moves)
  SPEED    = self.new('Speed', :speed)
  NAME     = self.new('Name', :name)
  POSITION = self.new('Position', :position)
  ALG      = self.new('Alg', :alg)
  ALG_P    = self.new('Shortest Solution', :alg)
  SHOW     = self.new('', :show)
  NOTES    = self.new('Notes', :notes)

  STARS    = self.new('☆', :stars)

  COP = self.new('COP', :cop, is_svg: true )
  EO  = self.new('EO',  :eo,  is_svg: true )
  EP  = self.new('EP',  :ep,  is_svg: true )

  def cell(presenter)
    presenter.send(@method)
  end

  def svg_params(presenter)
    presenter.send(@method)
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
    { icon: Icons::Cop.for(@position), label: ''}
  end

  def eo
    { icon: Icons::Eo.for(@position), label: ''}
  end

  def ep
    { icon: Icons::Ep.for(@position), label: ''}
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

  def ui_pos
    @raw_alg.position.pov_variant_in(@context[:selected_pos_ids])
  end


  def alg
    tag(:td, Algs.shift(@raw_alg.moves, ui_pos.pov_offset), 'js-alg')
  end

  def speed
    tag(:td, '%.2f' % @raw_alg.speed, @raw_alg.speed == @context[:stats]&.fastest ? 'optimal' : nil)
  end

  def moves
    tag(:td, @raw_alg.length, @raw_alg.length == @context[:stats]&.shortest ? 'optimal' : nil)
  end

  def name
    tag(:td, @raw_alg.name, 'single')
  end

  def show
    td_tag(tag(:a, 'show', 'show-pig'), :'data-uset' => (@raw_alg.u_setup + ui_pos.pov_adjust_u_setup) % 4 )
  end

  def notes
    tag(:td, [@raw_alg.specialness, @raw_alg.nick_name].compact.join(' '))
  end

  def stars
    stars = @raw_alg.stars
    data = {aid: @raw_alg.id}
    data[:present] = stars.join(' ') if stars.present?

    # NOTE that there is a duplicate implementation of this in the AJAX handler
    hlp.content_tag(:td, stars.map{|star_id| tag(:span, '', "star#{star_id}") }.join.html_safe, class: :stars_td, data: data)
  end
end


class ComboAlgColumns
  attr_reader :speed, :moves, :show, :notes, :position, :cop, :eo, :ep, :stars

  def initialize(combo_alg, context)
    @combo_alg = combo_alg
    @context = context

    @speed = @moves = @show = @notes = @position = tag(:td, '')
    @cop = @eo = @ep = @stars = nil
  end

  def alg
    result = ''.html_safe
    @combo_alg.merge_display_data.each { |part| result += tag(:span, part[0], part[1]) }
    tag(:td, result, 'js-combo')
  end

  def name
    tag(:td, tag(:span, @combo_alg.alg1.name, 'js-goto-post') + '+' + tag(:span, @combo_alg.alg2.name, 'js-goto-post'), 'combo')
  end
end