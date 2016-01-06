# As a "view presenter" class, it makes sense to me to put this in the View helpers directory. DHH may disagree.

class Cols
  attr_reader :is_svg, :svg_config, :header

  def initialize(header, content, svg_config = nil)
    @header = header
    @content = content
    @is_svg = svg_config.present?
    @svg_config = svg_config
  end

  def with_header(new_header)
    Cols.new(new_header, @content, @svg_config)
  end

  MOVES = Cols.new('Moves',
      -> (alg, flags) { td_tag(as_alg(alg).length, highlight(flags[:shortest], flags[:copy])) }
  )
  MOVES_P = MOVES.with_header('')

  SPEED = Cols.new('Speed',
    -> (alg, flags) { td_tag('%.2f' % as_alg(alg).speed, highlight(flags[:fastest], flags[:copy])) }
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
  COP = Cols.new('COP', nil, -> (aop, flags) do {icon: Icons::Cop.for(as_pos(aop, flags.call(aop))), size: 22, label: ''} end)
  EO  = Cols.new('EO',  nil, -> (aop, flags) do {icon: Icons::Eo.for(as_pos(aop, flags.call(aop))),  size: 22, label: ''} end)
  EP  = Cols.new('EP',  nil, -> (aop, flags) do {icon: Icons::Ep.for(as_pos(aop, flags.call(aop))),  size: 22, label: ''} end)

  POSITION = Cols.new('Position',
    -> (aop, flags) do
      pos = as_pos(aop, flags)
      td_tag(h.link_to(pos.display_name, "/positions/#{pos.ll_code}"))
    end
  )
  ALG = Cols.new('Alg',
    -> (aop, flags) { td_tag(Algs.rotate_by_U(as_alg(aop).moves, as_pos(aop, flags).pov_offset), class: :alg) }
  )
  ALG_P = ALG.with_header('Shortest Solution')

  SHOW = Cols.new('',
    -> (aop, flags) do
      pov_adjust = as_pos(aop, flags).pov_adjust_u_setup
      td_tag(h.content_tag(:a, 'show', class: 'show-pig'), :'data-uset' => (as_alg(aop).u_setup + pov_adjust) % 4 )
    end
  )
  NOTES = Cols.new('Notes',
      -> (alg, flags) { td_tag(as_alg(alg).specialness) }
  )
  SOLUTIONS = Cols.new('Solutions',
      -> (pos, flags) { td_tag(as_pos(pos, flags).alg_count) }
  )

  def td(alg, flags)
    @content.call(alg, flags)
  end

  def self.h
    ActionController::Base.helpers
  end

  def self.td_tag(content, options = nil)
    h.content_tag(:td, content, options)
  end

  def self.highlight(optimal, copy)
    class_names = [optimal ? 'optimal' : nil, copy ? 'copy' : nil].join
    class_names.present? ? {class: class_names} : {}
  end

  def self.as_pos(alg_or_pos, flags)
    alg_or_pos.respond_to?(:position) ? alg_or_pos.position.pov_variant_in(flags[:selected_pos_ids]) : alg_or_pos
  end

  def self.as_alg(alg_or_pos)
    alg_or_pos.respond_to?(:best_alg) ? (alg_or_pos.best_alg || OpenStruct.new) : alg_or_pos
  end

end