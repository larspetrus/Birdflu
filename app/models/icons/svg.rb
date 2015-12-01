# Makes SVG cube icons

class Icons::Svg
  Point = Struct.new(:x, :y)

  def self.init_dimensions
    box_size = 100
    @@box_size = box_size
    cube_size = 80.0
    cube_margin = (box_size - cube_size)/2
    cube_end = cube_margin + cube_size
    stk_width = 23.5
    stk_gap = (cube_size - 3*stk_width)/4
    stk_distance = stk_width + stk_gap
    @@stk_distance = stk_distance
    stk_z1 = cube_margin+stk_gap
    stk_z2 = stk_z1+stk_distance
    stk_z3 = stk_z2+stk_distance

    @@cube_margin = cube_margin
    
    fw = 0.6*cube_margin
    f0 = cube_margin - fw

    def self.perspective(b1, b2, w, h, alt=0.0, side)
      axis1 = [bend(b1, alt), bend(b1+w, alt), bend(b1+w, alt+h), bend(b1, alt+h)]
      axis2 = [b2, b2, b2+h, b2+h, b2+h]

      if [:R, :L].include? side
        axis1, axis2 = axis2.map{|i| 100-i}, axis1
      end
      if [:R, :B].include? side
        axis1 = axis1.map{|i| 100-i}
        axis2 = axis2.map{|i| 100-i}
      end
      { points: (0..3).map{|i| "#{axis1[i]},#{axis2[i]}" }.join(' ')}
    end

    def self.bend(z, altitude)
      f = 0.96 - 0.2*altitude/@@cube_margin
      50 + (z - 50)*f
    end

    @@cube_rect = {x:cube_margin, y:cube_margin, width:cube_size, height:cube_size, rx: 3}
        d = stk_gap/10
    @@shaded_sides = [
        perspective(cube_margin, cube_end-d, cube_size, cube_margin+d, 0, :F).merge(fill: 'url(#shade_F)'),
        perspective(cube_margin, cube_end-d, cube_size, cube_margin+d, 0, :R).merge(fill: 'url(#shade_R)'),
        perspective(cube_margin, cube_end-d, cube_size, cube_margin+d, 0, :L).merge(fill: 'url(#shade_L)'),
        perspective(cube_margin, cube_end-d, cube_size, cube_margin+d, 0, :B).merge(fill: 'url(#shade_B)'),
    ]

    @@u_stickers = {
      ULB_U: {x:stk_z1, y:stk_z1, width:stk_width, height:stk_width, rx: 1},
      UB_U:  {x:stk_z2, y:stk_z1, width:stk_width, height:stk_width, rx: 1},
      UBR_U: {x:stk_z3, y:stk_z1, width:stk_width, height:stk_width, rx: 1},

      UL_U:  {x:stk_z1, y:stk_z2, width:stk_width, height:stk_width, rx: 1},
      U:     {x:stk_z2, y:stk_z2, width:stk_width, height:stk_width, rx: 1},
      UR_U:  {x:stk_z3, y:stk_z2, width:stk_width, height:stk_width, rx: 1},

      UFL_U: {x:stk_z1, y:stk_z3, width:stk_width, height:stk_width, rx: 1},
      UF_U:  {x:stk_z2, y:stk_z3, width:stk_width, height:stk_width, rx: 1},
      URF_U: {x:stk_z3, y:stk_z3, width:stk_width, height:stk_width, rx: 1},
    }
    @@plain_side_stickers = {
      ULB_B: {x:stk_z1, y:0, width:stk_width, height:cube_margin},
      UB_B:  {x:stk_z2, y:0, width:stk_width, height:cube_margin},
      UBR_B: {x:stk_z3, y:0, width:stk_width, height:cube_margin},

      UBR_R: {x:cube_end, y:stk_z1, width:cube_margin, height:stk_width},
      UR_R:  {x:cube_end, y:stk_z2, width:cube_margin, height:stk_width},
      URF_R: {x:cube_end, y:stk_z3, width:cube_margin, height:stk_width},

      UFL_F: {x:stk_z1, y:cube_end, width:stk_width, height:cube_margin},
      UF_F:  {x:stk_z2, y:cube_end, width:stk_width, height:cube_margin},
      URF_F: {x:stk_z3, y:cube_end, width:stk_width, height:cube_margin},

      ULB_L: {x:0, y:stk_z1, width:cube_margin, height:stk_width},
      UL_L:  {x:0, y:stk_z2, width:cube_margin, height:stk_width},
      UFL_L: {x:0, y:stk_z3, width:cube_margin, height:stk_width},
    }
    @@fancy_side_stickers = {
      UBR_B: perspective(stk_z1, cube_end,    stk_width, fw,  0, :B),
      UB_B:  perspective(stk_z2, cube_end,    stk_width, fw,  0, :B),
      ULB_B: perspective(stk_z3, cube_end,    stk_width, fw,  0, :B),
      B:     perspective(stk_z2, cube_end+fw, stk_width, f0, fw, :B),

      URF_R: perspective(stk_z1, cube_end,    stk_width, fw,  0, :R),
      UR_R:  perspective(stk_z2, cube_end,    stk_width, fw,  0, :R),
      UBR_R: perspective(stk_z3, cube_end,    stk_width, fw,  0, :R),
      R:     perspective(stk_z2, cube_end+fw, stk_width, f0, fw, :R),

      UFL_F: perspective(stk_z1, cube_end,    stk_width, fw,  0, :F),
      UF_F:  perspective(stk_z2, cube_end,    stk_width, fw,  0, :F),
      URF_F: perspective(stk_z3, cube_end,    stk_width, fw,  0, :F),
      F:     perspective(stk_z2, cube_end+fw, stk_width, f0, fw, :F),

      ULB_L: perspective(stk_z1, cube_end,    stk_width, fw,  0, :L),
      UL_L:  perspective(stk_z2, cube_end,    stk_width, fw,  0, :L),
      UFL_L: perspective(stk_z3, cube_end,    stk_width, fw,  0, :L),
      L:     perspective(stk_z2, cube_end+fw, stk_width, f0, fw, :L),
    }
    @@icon_stickers  = @@u_stickers.merge(@@plain_side_stickers)
    @@fancy_stickers = @@u_stickers.merge(@@fancy_side_stickers)
  end
  self.init_dimensions

  def self.box_size
    @@box_size
  end

  def self.tags_for(icon)
    sticker_set = icon.look_3d? ? @@fancy_stickers : @@icon_stickers

    result = icon.look_3d? ? @@shaded_sides + [@@cube_rect] : [@@cube_rect]
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
            offset = ([:R, :F].include?(place) ? @@stk_distance : -@@stk_distance)
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