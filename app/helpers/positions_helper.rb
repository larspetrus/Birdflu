# frozen_string_literal: true

module PositionsHelper
  def svg_cell(presenter, method)
    svg_params = presenter.send(method)
    icon = render 'cube_icon', svg_params
    content_tag(:td, icon)
  end

end

# "View presenter" code for the alg/position list/table columns.

class Column
  attr_reader :is_svg, :svg_config, :header

  def initialize(header, method, is_svg: false)
    @header = header
    @method = method
    @is_svg = is_svg
  end

  ALL = {
      length:      self.new('Moves', :moves),
      length_p:    self.new('', :moves),
      speed:       self.new('Speed', :speed),
      name:        self.new('Name', :name),
      position:    self.new('Position', :position),
      alg:         self.new('Alg', :alg),
      alg_p:       self.new('Shortest Solution', :alg),
      show:        self.new('', :show),
      notes:       self.new('Notes', :notes),
      stars:       self.new('☆', :stars),
      hl_position: self.new('Position', :hl_position),
      remove_star: self.new('', :remove_star),
      cop:         self.new('COP', :cop, is_svg: true),
      eo:          self.new('EO',  :eo,  is_svg: true),
      ep:          self.new('EP',  :ep,  is_svg: true),
      eop:         self.new('EOP', :eop, is_svg: true),
  }.freeze

  def self.[](name)
    ALL[name]
  end

  def self.named(names)
    names.each{|name| raise "Bad column name '#{name}'" unless self[name] }
    names.map{|name| self[name]}
  end

  def content(presenter)
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

  def eop
    { icon: Icons::Eop.for(@position), label: ''}
  end
end


class RawAlgColumns
  delegate :cop, :eo, :ep, :eop, :big, :position, :to => :pos_cols

  def initialize(raw_alg, context, pos_cols = nil)
    @raw_alg = raw_alg
    @context = context
    @pos_cols = pos_cols
  end

  def pos_cols
    @pos_cols ||= PositionColumns.new(@raw_alg.position, self)
  end

  def ui_pos
    @raw_alg.non_db? ?
        OpenStruct.new(pov_offset: 0, pov_adjust_u_setup: 0) :
        @raw_alg.position.pov_variant_in(@context[:possible_pos_ids])
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
    if @context[:stars]
      star_styles = @context[:stars][@raw_alg.id]
    elsif @context[:login]
      star_styles = @raw_alg.star_styles(@context[:login].db_id)
    else
      star_styles = []
    end
    data = {aid: @raw_alg.id}
    data[:deletable] = star_styles.join(' ') if star_styles.present?

    # NOTE that there is a duplicate implementation of this in the AJAX handler
    hlp.content_tag(:td, star_styles.map{|style| tag(:span, '', "star#{style}") }.join.html_safe, class: :stars_td, data: data)
  end

  def hl_position
    tag(:td, hlp.link_to(@raw_alg.position.display_name, "/?pos=#{@raw_alg.position.display_name}&hl_id=#{@raw_alg.id}"))
  end

  def remove_star
    star = @context[:star]
    tag(:td, hlp.link_to('Remove', "/galaxies/remove_star?galaxy_id=#{star.galaxy_id}&raw_alg_id=#{star.raw_alg_id}", class: 'knapp knapp-enabled'))
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
    @combo_alg.merge_display_data.each { |part| result += tag(:span, part[0], part[1]) }
    tag(:td, result, 'js-combo')
  end

  def name
    tag(:td, tag(:span, @combo_alg.alg1.name, 'js-goto-post') + '+' + tag(:span, @combo_alg.alg2.name, 'js-goto-post'), 'combo')
  end

  def stars
    td_tag('')
  end
end