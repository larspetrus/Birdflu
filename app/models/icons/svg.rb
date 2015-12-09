# Makes SVG cube icons

class Icons::Svg # TODO ::Geometry
  Point = Struct.new(:x, :y)

  VIEWBOX_SIZE = 100
  CUBE_SIZE = 80.0
  MARGIN = (VIEWBOX_SIZE - CUBE_SIZE)/2
  STK_SIZE = 23.5
  STK_GAP = (CUBE_SIZE - 3*STK_SIZE)/4
  STK_DISTANCE = STK_SIZE + STK_GAP

  CUBE_RECT = {x: MARGIN, y: MARGIN, width: CUBE_SIZE, height: CUBE_SIZE, rx: 3}
  CUBE_END = MARGIN + CUBE_SIZE

  STK_Z1 = MARGIN+STK_GAP
  STK_Z2 = STK_Z1+STK_DISTANCE
  STK_Z3 = STK_Z2+STK_DISTANCE

  FW = 0.6*MARGIN
  F0 = MARGIN - FW

  D = STK_GAP/10 # line up with rounded corners

  def self.depth(side, x, y, w, h)
    x_values = [deep(x, y), deep(x+w, y), deep(x+w, y+h), deep(x, y+h)]
    y_values = [y, y, y+h, y+h, y+h]

    if [:R, :L].include? side
      x_values, y_values = y_values.map{|i| VIEWBOX_SIZE-i}, x_values
    end
    if [:R, :B].include? side
      x_values = x_values.map{|i| VIEWBOX_SIZE-i}
      y_values = y_values.map{|i| VIEWBOX_SIZE-i}
    end
    { points: (0..3).map{|i| "#{x_values[i]},#{y_values[i]}" }.join(' ')}
  end

  # The rectangle defined by the (x,y) point and w(idth) / h(eight) is "squeezed" into perspective by
  # narrowing the x values to the center, proportional to "altitude" from the cube edge.
  def self.deep(x, y)
    adjust1, adjust2 = STK_GAP*0.4, 0.972   # line up with rounded corners
    altitude = y - (MARGIN + CUBE_SIZE - adjust1)

    f = adjust2 - 0.2*altitude/MARGIN
    50 + (x - 50)*f
  end

  def self.u_sticker(x, y)
    {x:x, y:y, width:STK_SIZE, height:STK_SIZE, rx: 1}
  end



  SHADED_SIDES = [
      depth(:F, MARGIN, CUBE_END-D, CUBE_SIZE, MARGIN+D).merge(fill: 'url(#shade_F)'),
      depth(:R, MARGIN, CUBE_END-D, CUBE_SIZE, MARGIN+D).merge(fill: 'url(#shade_R)'),
      depth(:L, MARGIN, CUBE_END-D, CUBE_SIZE, MARGIN+D).merge(fill: 'url(#shade_L)'),
      depth(:B, MARGIN, CUBE_END-D, CUBE_SIZE, MARGIN+D).merge(fill: 'url(#shade_B)'),
  ]

  U_STICKERS = {
    ULB_U: u_sticker(STK_Z1, STK_Z1),
    UB_U:  u_sticker(STK_Z2, STK_Z1),
    UBR_U: u_sticker(STK_Z3, STK_Z1),

    UL_U:  u_sticker(STK_Z1, STK_Z2),
    U:     u_sticker(STK_Z2, STK_Z2),
    UR_U:  u_sticker(STK_Z3, STK_Z2),

    UFL_U: u_sticker(STK_Z1, STK_Z3),
    UF_U:  u_sticker(STK_Z2, STK_Z3),
    URF_U: u_sticker(STK_Z3, STK_Z3),
  }

  PLAIN_SIDE_STICKERS = {
    ULB_B: {x:STK_Z1, y:0, width:STK_SIZE, height:MARGIN},
    UB_B:  {x:STK_Z2, y:0, width:STK_SIZE, height:MARGIN},
    UBR_B: {x:STK_Z3, y:0, width:STK_SIZE, height:MARGIN},

    UBR_R: {x:CUBE_END, y:STK_Z1, width:MARGIN, height:STK_SIZE},
    UR_R:  {x:CUBE_END, y:STK_Z2, width:MARGIN, height:STK_SIZE},
    URF_R: {x:CUBE_END, y:STK_Z3, width:MARGIN, height:STK_SIZE},

    UFL_F: {x:STK_Z1, y:CUBE_END, width:STK_SIZE, height:MARGIN},
    UF_F:  {x:STK_Z2, y:CUBE_END, width:STK_SIZE, height:MARGIN},
    URF_F: {x:STK_Z3, y:CUBE_END, width:STK_SIZE, height:MARGIN},

    ULB_L: {x:0, y:STK_Z1, width:MARGIN, height:STK_SIZE},
    UL_L:  {x:0, y:STK_Z2, width:MARGIN, height:STK_SIZE},
    UFL_L: {x:0, y:STK_Z3, width:MARGIN, height:STK_SIZE},
  }

  FANCY_SIDE_STICKERS = {
    UBR_B: depth(:B, STK_Z1, CUBE_END,    STK_SIZE, FW),
    UB_B:  depth(:B, STK_Z2, CUBE_END,    STK_SIZE, FW),
    ULB_B: depth(:B, STK_Z3, CUBE_END,    STK_SIZE, FW),
    B:     depth(:B, STK_Z2, CUBE_END+FW, STK_SIZE, F0),

    URF_R: depth(:R, STK_Z1, CUBE_END,    STK_SIZE, FW),
    UR_R:  depth(:R, STK_Z2, CUBE_END,    STK_SIZE, FW),
    UBR_R: depth(:R, STK_Z3, CUBE_END,    STK_SIZE, FW),
    R:     depth(:R, STK_Z2, CUBE_END+FW, STK_SIZE, F0),

    UFL_F: depth(:F, STK_Z1, CUBE_END,    STK_SIZE, FW),
    UF_F:  depth(:F, STK_Z2, CUBE_END,    STK_SIZE, FW),
    URF_F: depth(:F, STK_Z3, CUBE_END,    STK_SIZE, FW),
    F:     depth(:F, STK_Z2, CUBE_END+FW, STK_SIZE, F0),

    ULB_L: depth(:L, STK_Z1, CUBE_END,    STK_SIZE, FW),
    UL_L:  depth(:L, STK_Z2, CUBE_END,    STK_SIZE, FW),
    UFL_L: depth(:L, STK_Z3, CUBE_END,    STK_SIZE, FW),
    L:     depth(:L, STK_Z2, CUBE_END+FW, STK_SIZE, F0),
  }
  ICON_STICKERS  = U_STICKERS.merge(PLAIN_SIDE_STICKERS)
  FANCY_STICKERS = U_STICKERS.merge(FANCY_SIDE_STICKERS)

  def self.box_dimension
    {viewBox: "0 0 #{VIEWBOX_SIZE} #{VIEWBOX_SIZE}"}
  end

  def self.tags_for(icon)
    result = (icon.is_illustration? ? SHADED_SIDES : []) + [CUBE_RECT]

    stickers = icon.is_illustration? ? FANCY_STICKERS : ICON_STICKERS
    stickers.keys.each do |sticker|
      color = icon.color_at(sticker)
      color ||= 'white' if sticker[-1] == 'U'
      if color
        result << {class: color}.merge!(stickers[sticker])
      end
    end

    icon.arrows.each do |place|
      result << Icons::Svg.arrow_on(place)
    end

    result
  end

  def self.arrow_on(place)

    result =
      case place
        when :L, :R, :B, :F, :LdR, :BdF
          transforms = []
          if [:B, :LdR, :F].include? place
            transforms << "rotate(90, 50, 50)"
          end

          if [:L, :R, :B, :F].include? place
            offset = ([:R, :F].include?(place) ? STK_DISTANCE : -STK_DISTANCE)
            transforms << "translate(#{offset}, 0)"
          end
          {d: long_double, transform: transforms.join(' ')}
        when :BdL, :BdR, :FdL, :FdR
          angle = {FdR: 45, FdL: 135, BdL: 225, BdR: 315}[place]
          {d: short_double, transform: "rotate(#{angle}, 50, 50)"}
        when :D
          {d: diagonal, transform: "rotate(45, 50, 50)"}
        when :F2B, :B2F, :R2L, :L2R
          angle = {F2B: 0, L2R: 90, B2F: 180, R2L: 270}[place]
          {d: long_single, transform: "rotate(#{angle}, 50, 50)"}
        when :B2R, :R2F, :F2L, :L2B
          angle = {R2F: 45, F2L: 135, L2B: 225, B2R: 315}[place]
          {d: short_single_reverse, transform: "rotate(#{angle}, 50, 50)"}
        when :R2B, :F2R, :L2F, :B2L
          angle = {F2R: 45, L2F: 135, B2L: 225, R2B: 315}[place]
          {d: short_single, transform: "rotate(#{angle}, 50, 50)"}
        else
          raise ArgumentError.new("Unknown arrow place '#{place}'")
      end

    type = ([:L, :R, :B, :F, :D].include?(place) ? 'c_arrow' : 'e_arrow')
    result.merge(class: type)
  end

  def self.double_arrow_points(line_h, line_w, head_h, head_w, cx=50, cy=50)
  [
    Point.new(cx-line_w,        cy-line_h),
    Point.new(cx-line_w-head_w, cy-line_h),
    Point.new(cx,               cy-line_h-head_h),
    Point.new(cx+line_w+head_w, cy-line_h),
    Point.new(cx+line_w,        cy-line_h),
    Point.new(cx+line_w,        cy+line_h),
    Point.new(cx+line_w+head_w, cy+line_h),
    Point.new(cx,               cy+line_h+head_h),
    Point.new(cx-line_w-head_w, cy+line_h),
    Point.new(cx-line_w,        cy+line_h),
  ]
  end

  def self.single_arrow_points(line_h, line_w, head_h, head_w, cx=50, cy=50)
  [
    Point.new(cx-line_w,        cy-line_h),
    Point.new(cx-line_w-head_w, cy-line_h),
    Point.new(cx,               cy-line_h-head_h),
    Point.new(cx+line_w+head_w, cy-line_h),
    Point.new(cx+line_w,        cy-line_h),
    Point.new(cx+line_w,        cy+line_h+head_h),
    Point.new(cx-line_w,        cy+line_h+head_h),
  ]
  end

  def self.path(points)
    result = ""
    prev = nil
    points.each do |pt|
      cmd =
          if not prev
            "M#{pt.x} #{pt.y}"
          elsif pt.x == prev.x
            "V#{pt.y}"
          elsif pt.y == prev.y
            "H#{pt.x}"
          else
            "L#{pt.x} #{pt.y}"
          end
      result += cmd
      prev = pt
    end
    result + "Z"
  end

  def self.long_double
    @long_double ||= path(double_arrow_points(22, 1, 7, 4))
  end

  def self.short_double
    @short_double ||= path(double_arrow_points(12, 1, 7, 4, 70))
  end

  def self.long_single
    @long_single ||= path(single_arrow_points(18, 1, 7, 4))
  end

  def self.short_single
    @short_single ||= path(single_arrow_points(12, 1, 7, 4, 73))
  end

  def self.short_single_reverse
    @short_single_reverse ||= path(single_arrow_points(-12, -1, -7, -4, 73))
  end

  def self.diagonal
    @diagonal ||= path(double_arrow_points(34, 1, 7, 4))
  end
end