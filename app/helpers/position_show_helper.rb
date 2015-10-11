module PositionShowHelper
  def first_2_headers(sortby)
    texts = ['Speed', 'Moves'].rotate(sortby == 'speed' ? 0 : 1)
    content_tag(:th, texts[0], class: 'sortby') + content_tag(:th, texts[1])
  end

  def first_2_columns(sortby, alg, copy)
    tags = [speed_value(alg), length_value(alg, copy)].rotate(sortby == 'speed' ? 0 : 1)
    tags[0] + tags[1]
  end

  def speed_value(alg)
    content_tag(:td, '%.2f' % alg.speed)
  end

  def length_value(alg, copy)
    classes = copy ? {class: 'copy'} : nil
    content_tag(:td, alg.length, classes)
  end
end
