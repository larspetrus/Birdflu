# Makes SVG cube icons

class Icons::Svg
  Point = Struct.new(:x, :y)

  VIEWBOX_SIZE = 100
  CUBE_SIZE = 80.0
  MARGIN = (VIEWBOX_SIZE - CUBE_SIZE)/2
  STK_SIZE = 23.5
  STK_GAP = (CUBE_SIZE - 3*STK_SIZE)/4
  STK_DISTANCE = STK_SIZE + STK_GAP

  def self.init_dimensions
    cube_end = MARGIN + CUBE_SIZE

    stk_z1 = MARGIN+STK_GAP
    stk_z2 = stk_z1+STK_DISTANCE
    stk_z3 = stk_z2+STK_DISTANCE


    fw = 0.6*MARGIN
    f0 = MARGIN - fw

    # The rectangle defined by the (x,y) point and w(idth) / h(eight) is "squeezed" into perspective by
    # narrowing the x values to the center, proportional to "altitude" from the cube edge.
    def self.perspective(x, y, w, h, alt=0.0, side)
      x_values = [far(x, alt), far(x+w, alt), far(x+w, alt+h), far(x, alt+h)]
      y_values = [y, y, y+h, y+h, y+h]

      if [:R, :L].include? side
        x_values, y_values = y_values.map{|i| 100-i}, x_values
      end
      if [:R, :B].include? side
        x_values = x_values.map{|i| 100-i}
        y_values = y_values.map{|i| 100-i}
      end
      { points: (0..3).map{|i| "#{x_values[i]},#{y_values[i]}" }.join(' ')}
    end

    def self.far(z, altitude)
      f = 0.96 - 0.2*altitude/MARGIN
      50 + (z - 50)*f
    end

    @@cube_rect = {x:MARGIN, y:MARGIN, width:CUBE_SIZE, height:CUBE_SIZE, rx: 3}

    d = STK_GAP/10 # line up with rounded corners
    @@shaded_sides = [
        perspective(MARGIN, cube_end-d, CUBE_SIZE, MARGIN+d, 0, :F).merge(fill: 'url(#shade_F)'),
        perspective(MARGIN, cube_end-d, CUBE_SIZE, MARGIN+d, 0, :R).merge(fill: 'url(#shade_R)'),
        perspective(MARGIN, cube_end-d, CUBE_SIZE, MARGIN+d, 0, :L).merge(fill: 'url(#shade_L)'),
        perspective(MARGIN, cube_end-d, CUBE_SIZE, MARGIN+d, 0, :B).merge(fill: 'url(#shade_B)'),
    ]

    @@u_stickers = {
      ULB_U: {x:stk_z1, y:stk_z1, width:STK_SIZE, height:STK_SIZE, rx: 1},
      UB_U:  {x:stk_z2, y:stk_z1, width:STK_SIZE, height:STK_SIZE, rx: 1},
      UBR_U: {x:stk_z3, y:stk_z1, width:STK_SIZE, height:STK_SIZE, rx: 1},

      UL_U:  {x:stk_z1, y:stk_z2, width:STK_SIZE, height:STK_SIZE, rx: 1},
      U:     {x:stk_z2, y:stk_z2, width:STK_SIZE, height:STK_SIZE, rx: 1},
      UR_U:  {x:stk_z3, y:stk_z2, width:STK_SIZE, height:STK_SIZE, rx: 1},

      UFL_U: {x:stk_z1, y:stk_z3, width:STK_SIZE, height:STK_SIZE, rx: 1},
      UF_U:  {x:stk_z2, y:stk_z3, width:STK_SIZE, height:STK_SIZE, rx: 1},
      URF_U: {x:stk_z3, y:stk_z3, width:STK_SIZE, height:STK_SIZE, rx: 1},
    }
    @@plain_side_stickers = {
      ULB_B: {x:stk_z1, y:0, width:STK_SIZE, height:MARGIN},
      UB_B:  {x:stk_z2, y:0, width:STK_SIZE, height:MARGIN},
      UBR_B: {x:stk_z3, y:0, width:STK_SIZE, height:MARGIN},

      UBR_R: {x:cube_end, y:stk_z1, width:MARGIN, height:STK_SIZE},
      UR_R:  {x:cube_end, y:stk_z2, width:MARGIN, height:STK_SIZE},
      URF_R: {x:cube_end, y:stk_z3, width:MARGIN, height:STK_SIZE},

      UFL_F: {x:stk_z1, y:cube_end, width:STK_SIZE, height:MARGIN},
      UF_F:  {x:stk_z2, y:cube_end, width:STK_SIZE, height:MARGIN},
      URF_F: {x:stk_z3, y:cube_end, width:STK_SIZE, height:MARGIN},

      ULB_L: {x:0, y:stk_z1, width:MARGIN, height:STK_SIZE},
      UL_L:  {x:0, y:stk_z2, width:MARGIN, height:STK_SIZE},
      UFL_L: {x:0, y:stk_z3, width:MARGIN, height:STK_SIZE},
    }
    @@fancy_side_stickers = {
      UBR_B: perspective(stk_z1, cube_end,    STK_SIZE, fw,  0, :B),
      UB_B:  perspective(stk_z2, cube_end,    STK_SIZE, fw,  0, :B),
      ULB_B: perspective(stk_z3, cube_end,    STK_SIZE, fw,  0, :B),
      B:     perspective(stk_z2, cube_end+fw, STK_SIZE, f0, fw, :B),

      URF_R: perspective(stk_z1, cube_end,    STK_SIZE, fw,  0, :R),
      UR_R:  perspective(stk_z2, cube_end,    STK_SIZE, fw,  0, :R),
      UBR_R: perspective(stk_z3, cube_end,    STK_SIZE, fw,  0, :R),
      R:     perspective(stk_z2, cube_end+fw, STK_SIZE, f0, fw, :R),

      UFL_F: perspective(stk_z1, cube_end,    STK_SIZE, fw,  0, :F),
      UF_F:  perspective(stk_z2, cube_end,    STK_SIZE, fw,  0, :F),
      URF_F: perspective(stk_z3, cube_end,    STK_SIZE, fw,  0, :F),
      F:     perspective(stk_z2, cube_end+fw, STK_SIZE, f0, fw, :F),

      ULB_L: perspective(stk_z1, cube_end,    STK_SIZE, fw,  0, :L),
      UL_L:  perspective(stk_z2, cube_end,    STK_SIZE, fw,  0, :L),
      UFL_L: perspective(stk_z3, cube_end,    STK_SIZE, fw,  0, :L),
      L:     perspective(stk_z2, cube_end+fw, STK_SIZE, f0, fw, :L),
    }
    @@icon_stickers  = @@u_stickers.merge(@@plain_side_stickers)
    @@fancy_stickers = @@u_stickers.merge(@@fancy_side_stickers)
  end
  self.init_dimensions

  def self.box_dimension
    {viewBox: "0 0 #{VIEWBOX_SIZE} #{VIEWBOX_SIZE}"}
  end

  def self.tags_for(icon)
    sticker_set = icon.is_illustration? ? @@fancy_stickers : @@icon_stickers

    result = icon.is_illustration? ? @@shaded_sides + [@@cube_rect] : [@@cube_rect]
    sticker_set.keys.each do |sticker|
      color = icon.color_at(sticker)
      color ||= 'white' if sticker[-1] == 'U'
      if color
        result << {class: color}.merge!(sticker_set[sticker])
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