# frozen_string_literal: true

class Icons::Base
  attr_reader :code, :name, :arrows, :field, :colors, :is_none, :id

  def initialize(form_field, code)
    @is_none = (code == :'')
    @name = (@is_none ? '-' : code.to_s)
    @id = "#{form_field}_#{@name}"

    @field = "##{form_field}"
    @code = code
    @arrows = []

    @colors = {}
    base_colors unless @is_none
  end

  def self.class_by(form_field)
    {cop: Icons::Cop, co: Icons::Co, cp: Icons::Cp, eo: Icons::Eo, ep: Icons::Ep, oll: Icons::Oll}[form_field]
  end

  def self.icon_by(form_field, code)
    class_by(form_field).by_code(code)
  end


  def self.icon_grid(code_rows)
    code_rows.map{|row| row.map{|id| self.by_code(id)}}
  end

  def set_colors(color_class, *stickers)
    stickers.each{|s| @colors[s] = color_class }
  end

  def color_at(sticker_code)
    @colors[sticker_code]
  end

  def is_illustration?
    false
  end

  def css_classes(selected_code, locked = false)
    return 'locked-pick-icon' if locked
    highlight = (selected_code&.to_sym == @code) && !@is_none
    highlight ? 'pick-icon selected' : 'pick-icon'
  end
end