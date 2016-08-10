class Player
  ROTATION_SPEED = 3
  ACCELERATION = 2
  FRICTION = 0.9

  def initialize(window)
    @x = 750
    @y = 750
    @angle = 0
    @image = Gosu::Image.new('images/pumpkin.png')
    @velocity_x = 0
    @velocity_y = 0
    @radius = 20
    @window = window
  end

  def draw
    @image.draw_rot(@x, @y, 0, @angle)
  end

  def turn_right
    @angle += ROTATION_SPEED
  end

  def turn_left
    @angle -= ROTATION_SPEED
  end

  def accelerate
    @velocity_x += Gosu.offset_x(@angle, ACCELERATION)
    @velocity_y += Gosu.offset_y(@angle, ACCELERATION)
  end

  def goback
    @velocity_x -= Gosu.offset_x(@angle, ACCELERATION)
    @velocity_y -= Gosu.offset_y(@angle, ACCELERATION)
  end

  def move
    @x += @velocity_x
    @y += @velocity_y
    @velocity_x *= FRICTION
    @velocity_y *= FRICTION
    if @x > @window.width - @radius then
      @velocity_x = 0
      @x = @window.width - @radius
    end
    if @x < @radius then
      @velocity_x = 0
      @x = @radius
    end
    if @y > @window.height - @radius then
      @velocity_y = 0
      @y = @window.height - @radius
    end
    if @y < @radius then
      @velocity_y = 0
      @y = @radius
    end
  end

end
