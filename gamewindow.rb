require "gosu"
require_relative "player"
require_relative "star"

module ZOrder
  Background, Stars, Player, UI = *0..3
end

class GameWindow < Gosu::Window
  
  def initialize
    super(640, 480)
    self.caption = "Gosu Tutorial Game"
    @background_image = Gosu::Image.new("media/space.png", :tileable => true)
    @player = Player.new
    @player.warp(320, 240)
    @star_anim = Gosu::Image::load_tiles("media/star.png", 25, 25)
    @stars = Array.new 
    @font = Gosu::Font.new(20)
  end

  def update
    if Gosu::button_down?(Gosu::KbLeft) || Gosu::button_down?(Gosu::GpLeft)
      @player.turn_left
    end
    if Gosu::button_down?(Gosu::KbRight) || Gosu::button_down?(Gosu::GpRight)
      @player.turn_right
    end
    if Gosu::button_down?(Gosu::KbUp) || Gosu::button_down?(Gosu::GpButton0)
      @player.accelerate
    end
    @player.move
    @player.collect_stars(@stars)
    
    if rand(100) < 4 && @stars.size < 25
      @stars.push(Star.new(@star_anim))
    end
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
    @stars.each { |star| star.draw }
    @font.draw("Score : #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
  end
  
  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

window = GameWindow.new
window.show