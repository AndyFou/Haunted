require 'gosu'
require_relative 'player'
require_relative 'enemy'
require_relative 'bullet'

class Haunted < Gosu::Window
  WIN_WIDTH = 900
  WIN_HEIGHT = 900
  ENEMY_FREQUENCY = 0.005

  def initialize       ## constructor
    super(WIN_WIDTH,WIN_HEIGHT)
    self.caption = "Haunted"

    @background_image = Gosu::Image.new('images/start_screen.jpeg')
    @scene = :start

    # Create fonts
    @small_font = Gosu::Font.new(18)
    @medium_font = Gosu::Font.new(28)
    @large_font = Gosu::Font.new(36)
    @xlarge_font = Gosu::Font.new(72)
  end

  def draw
    case @scene
    when :start
      draw_start
    when :game
      draw_game
    when :end
      draw_end
    end
  end

  def draw_start
    @background_image.draw(0,0,0)
    @xlarge_font.draw("Welcome to Haunted!", 100, 200, 0, 1.0, 1.0, 0xff_000000)
  end

  def draw_game
    # Draw player, bullets and enemies
    @player.draw
    @enemies.each do |enemy|
      enemy.draw
    end
    @bullets.each do |bullet|
      bullet.draw
    end

    @small_font.draw("Background Image: www.freevectors.net, Other Images: www.iconarchive.com", 10, 880, 0, 1.0, 1.0, 0xff_ffffff)
    @medium_font.draw("Score: " + @score.to_s + " \t Time: " + @time_left.to_s, 650, 10, 0, 1.0, 1.0, 0xff_ffff00)
  end

  def draw_end
  end

  def update
    case @scene
    when :game
      update_game
    when :end
      update_end
    end
  end

  def update_game
  end

  def update_end
  end

  def button_down(id)
    case @scene
    when :start
      button_down_start(id)
    when :game
      button_down_game(id)
    when :end
      button_down_end(id)
    end
  end

  def button_down_start(id)
    initialize_game
  end

  def initialize_game
    # Create player, bullets and enemies
    @player = Player.new(self)
    @enemies = []
    @bullets = []
    @scene = :game
    @start_time = 0     # time since new game started
    @score = 0          # keep track of score
  end

end

window = Haunted.new
window.show
