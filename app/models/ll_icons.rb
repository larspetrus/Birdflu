class LlIcons
  attr_reader :code, :name, :arrows, :field, :colors

  def initialize(form_field, code)
    @is_none = (code == :'')

    @field = "##{form_field}"
    @code = code
    @arrows = []

    @colors = {}
    base_colors unless @is_none
  end

  def highlight(selected_name)
    'selected' if (selected_name || '').to_sym == @code
  end

  def set_colors(color_class, *stickers)
    stickers.each{|s| @colors[s] = color_class }
  end

  def color_at(sticker_code)
    @colors[sticker_code]
  end
end