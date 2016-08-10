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

    # Create images
    @background_image = Gosu::Image.new("images/background.jpg", :tileable => true)
    @star = Gosu::Image.new("images/star.png")

    # Create player, bullets and enemies
    @player = Player.new(self)
    @enemies = []
    @bullets = []

    # Create fonts
    @small_font = Gosu::Font.new(18)
    @medium_font = Gosu::Font.new(28)
    @large_font = Gosu::Font.new(36)
    @xlarge_font = Gosu::Font.new(72)

    # Other variables
    @playing = true     # check if game is over
    @go_color = Gosu::Color::BLACK      # game over background color
    @start_time = 0     # time since new game started
    @score = 0          # keep track of score
  end


  def draw
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

    # Draw fonts
    @large_font.draw("Welcome to Haunted!", 10, 10, 0, 1.0, 1.0, 0xff_ffff00)
    @small_font.draw("Background Image: www.freevectors.net, Other Images: www.iconarchive.com", 10, 880, 0, 1.0, 1.0, 0xff_ffffff)
    @medium_font.draw("Score: " + @score.to_s + " \t Time: " + @time_left.to_s, 650, 10, 0, 1.0, 1.0, 0xff_ffff00)

    # If time is up, draw game over scene
    unless @playing
      draw_quad(0, 0, @go_color, 900, 0, @go_color, 900, 900, @go_color, 0, 900, @go_color)
      @xlarge_font.draw('Game Over!', 280, 200, 3, 1.0, 1.0, 0xff_ffff00)
      @large_font.draw('Your Score is: ' + @score.to_s, 330, 300, 3, 1.0, 1.0, 0xff_ffff00)
      @large_font.draw('Press Enter to Play Again', 260, 400, 3)
    end
  end


  def update
    # if time is not up
    if @playing

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
      end

      # collision handling (when bullets hit enemies)
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

      # make game over if time is up
      @time_left = (20 - ((Gosu.milliseconds - @start_time) / 1000))
      @playing = false if @time_left <= 0
    end
  end


  def button_down(id)
    # reset the game
    if id == Gosu::KbReturn
      @playing = true
      @start_time = Gosu.milliseconds
      ### how to reset the player position??
    end

    # fire bullets
    if id == Gosu::KbSpace
      @bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
    end

    # #  quit the game if escape is pressed
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
