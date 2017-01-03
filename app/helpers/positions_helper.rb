# frozen_string_literal: true

module PositionsHelper
  def svg_cell(presenter, method)
    svg_params = presenter.send(method)
    icon = render 'cube_icon', svg_params
    content_tag(:td, icon)
  end

end
