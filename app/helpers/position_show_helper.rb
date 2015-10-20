module PositionShowHelper
  def first_2_headers(sortby)
    texts = ['Speed', 'Moves'].rotate(sortby == 'speed' ? 0 : 1)
    content_tag(:th, texts[0], class: 'sortby') + content_tag(:th, texts[1])
  end

  def first_2_columns(sortby, alg, flags)
    tags = [speed_value(alg, flags), length_value(alg, flags)].rotate(sortby == 'speed' ? 0 : 1)
    tags[0] + tags[1]
  end

  def speed_value(alg, flags)
    content_tag(:td, '%.2f' % alg.speed, class_for(flags[:fastest], flags[:copy]))
  end

  def length_value(alg, flags)
    content_tag(:td, alg.length, class_for(flags[:shortest], flags[:copy]))
  end

  def class_for(optimal, copy)
    class_names = [optimal ? 'optimal' : nil, copy ? 'copy' : nil].join
    class_names.present? ? {class: class_names} : {}
  end


  def alg_name_td(alg)
    if alg.oneAlg?
      alg.name
    else
      names = alg.name.split('+')
      content_tag(:span, names[0], class: 'goto-pos') + '+' + content_tag(:span, names[1], class: 'goto-pos')
    end
  end
end
