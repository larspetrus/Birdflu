module PositionShowHelper
  def first_2_headers(sortby)
    texts = ['Speed', 'Moves'].rotate(sortby == 'speed' ? 0 : 1)
    content_tag(:th, texts[0], class: 'sortby') + content_tag(:th, texts[1])
  end

  def first_2_columns(sortby, alg, flags)
    tags = [speed_value(alg), length_value(alg, flags)].rotate(sortby == 'speed' ? 0 : 1)
    tags[0] + tags[1]
  end

  def speed_value(alg)
    content_tag(:td, '%.2f' % alg.speed)
  end

  def length_value(alg, flags)
    class_names = [flags[:shortest] ? 'optimal' : nil, flags[:copy] ? 'copy' : nil].join
    classes = class_names.present? ? {class: class_names} : {}
    content_tag(:td, alg.length, classes)
  end
end
