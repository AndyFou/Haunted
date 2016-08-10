class Bullet
  SPEED = 5

  def initialize(window, x, y, angle)
    @x = x
    @y = y
    @direction = angle
    @image = Gosu::Image.new('images/candycorn-s.png')
    @radius = 3
    @window = window
  end

  def draw
    @image.draw(@x - @radius, @y - @radius, 0)
  end

  def move
    @x += Gosu.offset_x(@direction, SPEED)
    @y += Gosu.offset_y(@direction, SPEED)
  end
end
