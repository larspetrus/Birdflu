# Makes SVG icons

class Icons::Svg
  Point = Struct.new(:x, :y)

  def self.init_dimensions
    box_size = 100
    @@box_size = box_size
    cube_size = 80.0
    cube_start = (box_size - cube_size)/2
    cube_end = cube_start + cube_size
    sticker_width = 23.5
    sticker_gap = (cube_size - 3*sticker_width)/4
    sticker_distance = sticker_width + sticker_gap
    @@sticker_distance = sticker_distance
    sticker_xy1 = cube_start+sticker_gap
    sticker_xy2 = sticker_xy1+sticker_distance
    sticker_xy3 = sticker_xy2+sticker_distance

    @@cube_rect = {x:cube_start, y:cube_start, width:cube_size, height:cube_size, rx: 3}

    @@dimensions = {
      ULB_B: {x:sticker_xy1, y:0, width:sticker_width, height:cube_start},
      UB_B:  {x:sticker_xy2, y:0, width:sticker_width, height:cube_start},
      UBR_B: {x:sticker_xy3, y:0, width:sticker_width, height:cube_start},

      UBR_R: {x:cube_end, y:sticker_xy1, width:cube_start, height:sticker_width},
      UR_R:  {x:cube_end, y:sticker_xy2, width:cube_start, height:sticker_width},
      URF_R: {x:cube_end, y:sticker_xy3, width:cube_start, height:sticker_width},

      UFL_F: {x:sticker_xy1, y:cube_end, width:sticker_width, height:cube_start},
      UF_F:  {x:sticker_xy2, y:cube_end, width:sticker_width, height:cube_start},
      URF_F: {x:sticker_xy3, y:cube_end, width:sticker_width, height:cube_start},

      ULB_L: {x:0, y:sticker_xy1, width:cube_start, height:sticker_width},
      UL_L:  {x:0, y:sticker_xy2, width:cube_start, height:sticker_width},
      UFL_L: {x:0, y:sticker_xy3, width:cube_start, height:sticker_width},

      ULB_U: {x:sticker_xy1, y:sticker_xy1, width:sticker_width, height:sticker_width, rx: 1},
      UB_U:  {x:sticker_xy2, y:sticker_xy1, width:sticker_width, height:sticker_width, rx: 1},
      UBR_U: {x:sticker_xy3, y:sticker_xy1, width:sticker_width, height:sticker_width, rx: 1},

      UL_U:  {x:sticker_xy1, y:sticker_xy2, width:sticker_width, height:sticker_width, rx: 1},
      U:     {x:sticker_xy2, y:sticker_xy2, width:sticker_width, height:sticker_width, rx: 1},
      UR_U:  {x:sticker_xy3, y:sticker_xy2, width:sticker_width, height:sticker_width, rx: 1},

      UFL_U: {x:sticker_xy1, y:sticker_xy3, width:sticker_width, height:sticker_width, rx: 1},
      UF_U:  {x:sticker_xy2, y:sticker_xy3, width:sticker_width, height:sticker_width, rx: 1},
      URF_U: {x:sticker_xy3, y:sticker_xy3, width:sticker_width, height:sticker_width, rx: 1},
    }
  end
  self.init_dimensions

  def self.box_size
    @@box_size
  end

  def self.rects_for(icon)
    result = [@@cube_rect]
    @@dimensions.keys.each do |sticker|
      color = icon.color_at(sticker)
      if sticker[-1] == 'U'
        color ||= 'white'
      end
      if color
        result << {class: color}.merge!(@@dimensions[sticker]) #'shape-rendering'=>"crispEdges"
      end
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
            offset = ([:R, :F].include?(place) ? @@sticker_distance : -@@sticker_distance)
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

    type = ([:L, :R, :B, :F, :D].include?(place) ? 'corner' : 'edge')
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