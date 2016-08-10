class Enemy
  attr_reader :x, :y, :radius     # shortcut for GETters

  def initialize(window)
    @radius = 50
    @x = rand(window.width - 2 * @radius) + @radius
    @y = rand(window.height - 2 * @radius) + @radius
    @image = Gosu::Image.new('images/pumpkin.png')
    @window = window
  end

  def draw
    @image.draw(@x - @radius, @y - @radius, 0)
  end

  # def move
  #   @x += Gosu.offset_x(@direction, SPEED)
  #   @y += Gosu.offset_y(@direction, SPEED)
  # end
end
