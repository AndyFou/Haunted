require 'gosu'
require_relative 'player'
require_relative 'enemy'
require_relative 'bullet'

class Haunted < Gosu::Window
  WIN_WIDTH = 900
  WIN_HEIGHT = 900
  ENEMY_FREQUENCY = 0.005
  # TARGET_WIDTH = 750
  # TARGET_HEIGHT = 780
  # TARGET_RADIUS = 50

  def initialize       ## constructor
    super(WIN_WIDTH,WIN_HEIGHT)
    self.caption = "Haunted"

    # Create images
    @background_image = Gosu::Image.new("images/background.jpg", :tileable => true)
    @star = Gosu::Image.new("images/star.png")
    #@target = Gosu::Image.new("images/pumpkin.png")
    #@graveyard = Gosu::Image.new("images/graveyard.png")

    # Create a player (from player.rb file)
    @player = Player.new(self)
    @enemies = []
    @bullets = []

    # Create fonts
    @welcome = Gosu::Font.new(36)
    @credits = Gosu::Font.new(18)
    @time = Gosu::Font.new(28)
    @game_over = Gosu::Font.new(72)

    @playing = true
    @go_color = Gosu::Color::BLACK
    @start_time = 0
    @score = 0
  end

  def draw             ## draw the items of the game
    # Draw images
    @background_image.draw(0,0,0)
    @star.draw(150, 680, 0)
    #@graveyard.draw(500, 760, 0)

    #@target.draw(TARGET_WIDTH,TARGET_HEIGHT,0)
    @player.draw
    @enemies.each do |enemy|
      enemy.draw
    end
    @bullets.each do |bullet|
      bullet.draw
    end

    # Draw fonts
    @welcome.draw("Welcome to Haunted!", 10, 10, 0, 1.0, 1.0, 0xff_ffff00)
    @credits.draw("Background Image: www.freevectors.net, Other Images: www.iconarchive.com", 10, 880, 0, 1.0, 1.0, 0xff_ffffff)
    @time.draw("Score: " + @score.to_s + " \t Time: " + @time_left.to_s, 650, 10, 0, 1.0, 1.0, 0xff_ffff00)

    unless @playing
      draw_quad(0,0,@go_color,900,0,@go_color,900,900,@go_color,0,900,@go_color)
      @game_over.draw('Game Over!', 300, 300, 3, 1.0, 1.0, 0xff_ffff00)
      @welcome.draw('Press Enter to Play Again', 280, 400, 3)
    end
  end

  def update      ## animate the game (where objects are moved and user actions are handled)
    if @playing
      @player.turn_left if button_down?(Gosu::KbLeft)
      @player.turn_right if button_down?(Gosu::KbRight)
      @player.accelerate if button_down?(Gosu::KbUp)
      @player.goback if button_down?(Gosu::KbDown)
      @player.move

      @bullets.each do |bullet|
        bullet.move
      end

      if rand < ENEMY_FREQUENCY
        @enemies.push Enemy.new(self)
      end

      @time_left = (10 - ((Gosu.milliseconds - @start_time) / 1000))

      @playing = false if @time_left <= 0

      @enemies.dup.each do |enemy|
        @bullets.dup.each do |bullet|
          distance = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y)
          if distance < enemy.radius + bullet.radius
            @enemies.delete enemy
            @bullets.delete bullet
            @score += 1
          end
        end
      end
    end

  end

  def button_down(id)
    if id == Gosu::KbReturn
      @playing = true
      @start_time = Gosu.milliseconds
      ### how to reset the player position??
    end

    if id == Gosu::KbSpace
      @bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
    end

    # if id == Gosu::KbEscape
    #   # terminate program
    # end
  end
end

window = Haunted.new    ## new Haunted class instance
window.show


# NOTES
#
# INSTANCE VARIABLE names always start with an @ symbol and are variables that are accessible from all the methods in a class.
# The DRAW() method is a special method in Gosu (Gosu::Image method) that is run automatically when you give the final command window.show.
# To get the top left corner of the image: x,y / To get the center of the image: x-width/2, y-height/2
#
