require 'gosu'
require_relative 'player'

class Haunted < Gosu::Window
  WIN_WIDTH = 900
  WIN_HEIGHT = 900
  TARGET_WIDTH = 150
  TARGET_HEIGHT = 680

  def initialize
    super(WIN_WIDTH,WIN_HEIGHT)
    @background_image = Gosu::Image.new("images/background.jpg", :tileable => true)
    @witch = Gosu::Image.new("images/witch.png")
    #@graveyard = Gosu::Image.new("images/graveyard.png")

    @target = Gosu::Image.new("images/star.png")
    self.caption = "Haunted"
    @player = Player.new(self)

    @welcome = Gosu::Font.new(36)
    @credits = Gosu::Font.new(18)
  end

  def draw
    @background_image.draw(0,0,0)
    @witch.draw(450, 200, 0)
    #@graveyard.draw(500, 760, 0)

    @target.draw(TARGET_WIDTH,TARGET_HEIGHT,0)
    @player.draw
    @welcome.draw("Welcome to Haunted!", 10, 10, 0, 1.0, 1.0, 0xff_ffff00)
    @credits.draw("Background Image: www.freevectors.net, Other Images: www.iconarchive.com", 10, 880, 0, 1.0, 1.0, 0xff_ffffff)
  end

  def update
    @player.turn_left if button_down?(Gosu::KbLeft)
    @player.turn_right if button_down?(Gosu::KbRight)
    @player.accelerate if button_down?(Gosu::KbUp)
    @player.goback if button_down?(Gosu::KbDown)
    @player.move
  end
end

window = Haunted.new
window.show
