class Bullet
  SPEED = 5
  attr_reader :x, :y, :radius     # shortcut for GETters

  def initialize(window, x, y, angle)
    @x = x
    @y = y
    @direction = 90
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
