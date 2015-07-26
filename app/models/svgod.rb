class Svgod
  Point = Struct.new(:x, :y)

  def self.init_dimensions
    box_size = 100
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

    @@cube_rect = {x:cube_start, y:cube_start, width:cube_size, height:cube_size}

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

      ULB_U: {x:sticker_xy1, y:sticker_xy1, width:sticker_width, height:sticker_width},
      UB_U:  {x:sticker_xy2, y:sticker_xy1, width:sticker_width, height:sticker_width},
      UBR_U: {x:sticker_xy3, y:sticker_xy1, width:sticker_width, height:sticker_width},

      UL_U:  {x:sticker_xy1, y:sticker_xy2, width:sticker_width, height:sticker_width},
      U:     {x:sticker_xy2, y:sticker_xy2, width:sticker_width, height:sticker_width},
      UR_U:  {x:sticker_xy3, y:sticker_xy2, width:sticker_width, height:sticker_width},

      UFL_U: {x:sticker_xy1, y:sticker_xy3, width:sticker_width, height:sticker_width},
      UF_U:  {x:sticker_xy2, y:sticker_xy3, width:sticker_width, height:sticker_width},
      URF_U: {x:sticker_xy3, y:sticker_xy3, width:sticker_width, height:sticker_width},
    }
  end
  self.init_dimensions

  def self.rects_for(iconf)
    result = [@@cube_rect]
    @@dimensions.keys.each do |sticker|
      color = iconf.colors[sticker]
      if sticker[-1] == 'U'
        color ||= 'white-hole'
      end
      if color
        result << {class: color}.merge!(@@dimensions[sticker])
      end
    end
    result
  end

  def self.arrow_on(place)
    result = {}
    transforms = []

    if [:L, :R, :B, :F, :S, :M].include? place
      result[:d] = arrow_path1
      if [:B, :S, :F].include? place
        transforms << "rotate(90, 50, 50)"
      end

      if [:L, :R, :B, :F].include? place
        offset = ([:R, :F].include?(place) ? @@sticker_distance : -@@sticker_distance)
        transforms << "translate(#{offset}, 0)"
      end
    end

    if [:BL, :BR, :FL, :FR].include? place
      result[:d] = arrow_path2
      angle = {FR: 45, FL: 135, BL: 225, BR: 315}[place]
      transforms << "rotate(#{angle}, 50, 50)"
    end

    result[:transform] = transforms.join(' ')
    result
  end

  def self.double_arrow_pts(lh, lw, ah, aw, cx=50, cy=50)
  [
    Point.new(cx-lw,    cy-lh),
    Point.new(cx-lw-aw, cy-lh),
    Point.new(cx,       cy-lh-ah),
    Point.new(cx+lw+aw, cy-lh),
    Point.new(cx+lw,    cy-lh),
    Point.new(cx+lw,    cy+lh),
    Point.new(cx+lw+aw, cy+lh),
    Point.new(cx,       cy+lh+ah),
    Point.new(cx-lw-aw, cy+lh),
    Point.new(cx-lw,    cy+lh),
  ]
  end

  def self.path(points)
    result = ""
    prev = nil
    points.each do |pt|
      cmd = if not prev
              "M#{pt.x} #{pt.y} "
            elsif pt.x == prev.x
              "V#{pt.y} "
            elsif pt.y == prev.y
              "H#{pt.x} "
            else
              "L#{pt.x} #{pt.y} "
            end
      result += cmd
      prev = pt
    end
    result + " Z"
  end

  def self.arrow_path1
    points = double_arrow_pts(20, 1, 7, 2)
    path(points)
  end

  def self.arrow_path2
    points = double_arrow_pts(10, 1, 7, 2, 70)
    path(points)
  end
end