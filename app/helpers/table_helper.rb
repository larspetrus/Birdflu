module TableHelper
  def class_for(optimal, copy)
    class_names = [optimal ? 'optimal' : nil, copy ? 'copy' : nil].join
    class_names.present? ? {class: class_names} : {}
  end

end

class Cols
  attr_reader :is_svg, :svg_locals, :header

  def initialize(header, value, svg_locals = nil)
    @header = header
    @value = value
    @is_svg = svg_locals.present?
    @svg_locals = svg_locals
  end

  MOVES = Cols.new('Moves',
      -> (alg, flags) { td_tag(as_alg(alg).length, class_for(flags[:shortest], flags[:copy])) }
  )
  MOVES_P = Cols.new('',
      -> (alg, flags) { td_tag(as_alg(alg).length, class_for(flags[:shortest], flags[:copy])) }
  )
  SPEED = Cols.new('Speed',
    -> (alg, flags) { td_tag('%.2f' % as_alg(alg).speed, class_for(flags[:fastest], flags[:copy])) }
  )
  NAME = Cols.new('Name',
    -> (aop, flags) do
      alg = as_alg(aop)
      content =
          if alg.single?
            alg.name
          else
            names = alg.name.split('+')
            h.content_tag(:span, names[0], class: 'goto-pos') + '+' + h.content_tag(:span, names[1], class: 'goto-pos')
          end

      td_tag(content, class: alg.css_kind)
    end
  )
  COP = Cols.new('COP', nil,
    -> (alg) do {icon: Icons::Cop.for(as_pos(alg)), size: 25, label: ''} end
  )
  EO = Cols.new('EO', nil,
    -> (alg) do {icon: Icons::Eo.for(as_pos(alg)), size: 25, label: ''} end
  )
  EP = Cols.new('EP', nil,
    -> (alg) do {icon: Icons::Ep.for(as_pos(alg)), size: 25, label: ''} end
  )
  POSITION = Cols.new('Position',
    -> (alg, flags) do
      td_tag(h.link_to(as_pos(alg).display_name, "/positions/#{as_pos(alg).ll_code}"))
    end
  )
  ALG = Cols.new('Alg',
    -> (alg, flags) { td_tag(as_alg(alg).moves) }
  )
  ALG_P = Cols.new('Shortest Solution',
    -> (alg, flags) { td_tag(as_alg(alg).moves) }
  )
  SHOW = Cols.new('',
    -> (alg, flags) { td_tag(h.content_tag(:a, 'show', class: 'show-pig'), :'data-us' => as_alg(alg).setup_moves) }
  )
  NOTES = Cols.new('Notes',
      -> (alg, flags) { td_tag(as_alg(alg).specialness) }
  )
  SOLUTIONS = Cols.new('Solutions',
      -> (alg, flags) { td_tag(as_pos(alg).alg_count) }
  )

  def td(alg, flags)
    @value.call(alg, flags)
  end

  def self.h
    ActionController::Base.helpers
  end

  def self.td_tag(content, options = nil)
    h.content_tag(:td, content, options)
  end

  def self.class_for(optimal, copy)
    class_names = [optimal ? 'optimal' : nil, copy ? 'copy' : nil].join
    class_names.present? ? {class: class_names} : {}
  end

  def self.as_pos(alg_or_pos)
    alg_or_pos.class == Position ? alg_or_pos : alg_or_pos.position
  end

  def self.as_alg(alg_or_pos)
    alg_or_pos.class == RawAlg ? alg_or_pos : (alg_or_pos.best_alg || OpenStruct.new)

  end

end