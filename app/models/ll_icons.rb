class LlIcons
  attr_reader :code, :name, :arrows, :hidden_field_selector, :colors

  def initialize(hidden_field, code)
    @is_none = code == :''

    @hidden_field_selector = "##{hidden_field}"
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

end