require 'gosu'
require_relative 'player'
require_relative 'enemy'
require_relative 'bullet'

class Haunted < Gosu::Window
  WIN_WIDTH = 900
  WIN_HEIGHT = 900
  ENEMY_FREQUENCY = 0.005
  MAX_ENEMIES = 1

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

  def initialize_scene1
    # Create images
    @background_image = Gosu::Image.new("images/background.jpg", :tileable => true)
    @star = Gosu::Image.new("images/star.png")

    # Create player, bullets and enemies
    @player = Player.new(self)
    @enemies = []
    @bullets = []
    @scene = :scene1
    @enemies_appeared = 0
    @enemies_destroyed = 0
  end

  def initialize_end
    #@msg = "You destroyed #{@enemies_destroyed} enemies!"
    #@bottom_msg = "Press Enter to play again, or ESC to quit!"
    @go_color = Gosu::Color::BLACK      # game over background color

    @scene = :end
  end

  def draw
    case @scene
    when :start
      draw_start
    when :scene1
      draw_scene1
    when :end
      draw_end
    end
  end

  def draw_start
    @background_image.draw(0,0,0)
  end

  def draw_scene1
    # Draw images
    @background_image.draw(0,0,0)
    @star.draw(150, 680, 0)

    # Draw player, bullets and enemies
    @player.draw
    @enemies.each do |enemy|
      enemy.draw
    end
    @bullets.each do |bullet|
      bullet.draw
    end

    @small_font.draw("Background Image: www.freevectors.net, Other Images: www.iconarchive.com", 10, 880, 0, 1.0, 1.0, 0xff_ffffff)
    @medium_font.draw("Score: " + @enemies_destroyed.to_s, 800, 10, 0, 1.0, 1.0, 0xff_ffff00)
  end

  def draw_end
    draw_quad(0, 0, @go_color, 900, 0, @go_color, 900, 900, @go_color, 0, 900, @go_color)
    @xlarge_font.draw('Game Over!', 280, 200, 3, 1.0, 1.0, 0xff_ffff00)
    @large_font.draw('Your Score is: ' + @enemies_destroyed.to_s, 330, 300, 3, 1.0, 1.0, 0xff_ffff00)
    @large_font.draw('Press Enter to Play Again', 260, 400, 3)
    @large_font.draw('Press Q to quit!', 260, 500, 3)
  end

  def update
    case @scene
    when :scene1
      update_scene1
    when :end
      update_end
    end
  end

  def update_scene1
    # move player
    @player.turn_left if button_down?(Gosu::KbLeft)
    @player.turn_right if button_down?(Gosu::KbRight)
    @player.accelerate if button_down?(Gosu::KbUp)
    @player.goback if button_down?(Gosu::KbDown)
    @player.move

    # move bullets
    @bullets.each do |bullet|
      bullet.move
    end

    # move enemies
    if rand < ENEMY_FREQUENCY
      @enemies.push Enemy.new(self)
      @enemies_appeared += 1
    end

    # collision handling (when bullets hit enemies)
    @enemies.dup.each do |enemy|
      @bullets.dup.each do |bullet|
        distance = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y)
        if distance < enemy.radius + bullet.radius
          @enemies.delete enemy
          @bullets.delete bullet
          @enemies_destroyed += 1
        end
      end
    end

    initialize_end if @enemies_appeared > MAX_ENEMIES
  end

  def update_end
  end

  def button_down(id)
    case @scene
    when :start
      button_down_start(id)
    when :scene1
      button_down_scene1(id)
    when :end
      button_down_end(id)
    end
  end

  def button_down_start(id)
    if id == Gosu::KbEscape
      close
    else
      initialize_scene1
    end
  end

  def button_down_scene1(id)
    if id==Gosu::KbSpace
      @bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
    end
  end

  def button_down_end(id)
    if id == Gosu::KbReturn
      initialize_scene1
    elsif id == Gosu::KbEscape
      close
    end
  end

end

window = Haunted.new
window.show
