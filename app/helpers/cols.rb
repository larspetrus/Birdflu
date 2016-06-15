# frozen_string_literal: true

# The
#
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
      -> (alg, flags) { tag(:td, as_alg(alg).length, highlight(flags[:shortest], flags[:copy])) }
  )
  MOVES_P = MOVES.with_header('')

  SPEED = Cols.new('Speed',
    -> (alg, flags) { tag(:td, '%.2f' % as_alg(alg).speed, highlight(flags[:fastest], flags[:copy])) }
  )
  NAME = Cols.new('Name',
    -> (aop, flags) do
      alg = as_alg(aop)
      content =
          if alg.single?
            alg.name
          else
            names = alg.name.split('+')
            tag(:span, names[0], 'goto-pos') + '+' + tag(:span, names[1], 'goto-pos')
          end
      tag(:td, content, 'single')
    end
  )
  COP = Cols.new('COP', nil, -> (aop, flags) do {icon: Icons::Cop.for(as_pos(aop, flags.call(aop))), size: 22, label: ''} end)
  EO  = Cols.new('EO',  nil, -> (aop, flags) do {icon: Icons::Eo.for(as_pos(aop, flags.call(aop))),  size: 22, label: ''} end)
  EP  = Cols.new('EP',  nil, -> (aop, flags) do {icon: Icons::Ep.for(as_pos(aop, flags.call(aop))),  size: 22, label: ''} end)

  POSITION = Cols.new('Position',
    -> (aop, flags) do
      pos = as_pos(aop, flags)
      tag(:td, h.link_to(pos.display_name, "/positions/#{pos.ll_code}"))
    end
  )
  ALG = Cols.new('Alg',
    -> (aop, flags) { tag(:td, Algs.shift(as_alg(aop).moves, as_pos(aop, flags).pov_offset), 'alg') }
  )
  ALG_P = ALG.with_header('Shortest Solution')

  SHOW = Cols.new('',
    -> (aop, flags) do
      pov_adjust = as_pos(aop, flags).pov_adjust_u_setup
      td_tag(tag(:a, 'show', 'show-pig'), :'data-uset' => (as_alg(aop).u_setup + pov_adjust) % 4 )
    end
  )
  NOTES = Cols.new('Notes',
      -> (alg, flags) { tag(:td, alg.specialness) }
  )
  COMBOS = Cols.new('Combos',
      -> (alg, flags) do
        result = tag(:span, '·')
        alg.combo_algs.each do |combo|
          result += tag(:span, combo.alg1.name, 'goto-pos') + '+' + tag(:span, combo.alg2.name, 'goto-pos') + " ·· "
          combo.recon.each do |part|
            result += tag(:span, part[0], part[1])
          end
        end
        tag(:td, result)
      end
  )
  SOLUTIONS = Cols.new('Solutions',
      -> (pos, flags) { tag(:td, as_pos(pos, flags).alg_count) }
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

  def self.tag(type, content, css_class = nil)
    h.content_tag(type, content, class: css_class)
  end

  def self.highlight(optimal, copy)
    return nil unless optimal || copy
    (optimal ? 'optimal' : '') + (copy ? 'copy' : '')
  end

  def self.as_pos(alg_or_pos, flags)
    alg_or_pos.respond_to?(:position) ? alg_or_pos.position.pov_variant_in(flags[:selected_pos_ids]) : alg_or_pos
  end

  def self.as_alg(alg_or_pos)
    alg_or_pos.respond_to?(:best_alg) ? (alg_or_pos.best_alg || OpenStruct.new) : alg_or_pos
  end

end
