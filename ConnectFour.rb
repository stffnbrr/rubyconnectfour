$LOAD_PATH.unshift(File.dirname(__FILE__) + '/') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/')
require 'rubygems'
require 'rubygame'
require 'Field.rb'
require 'AIPlayer.rb'
include Rubygame

class ConnectFour

  SCREEN_WIDTH = 1000
  SCREEN_HEIGHT = 600
  CIRCLE_RADIUS = 40
  FONTSIZE_NORMAL = 20
  FONTSIZE_HEADLINE = 30

  @game_over = false
  @@fontNormal = nil
  @@fontHeadline = nil

  @@slots = Hash.new
  @@slots[0] = (10..90)
  @@slots[1] = (110..190)
  @@slots[2] = (210..290)
  @@slots[3] = (310..390)
  @@slots[4] = (410..490)
  @@slots[5] = (510..590)
  @@slots[6] = (610..690)
    def winner?(player)
    column_count(player) ||
    row_count(player)||
    forward_diagonal_count(player) ||
    backward_diagonal_count(player)
  end

  # -1 = AIPlayer
  def initialize field
    @field = field
    @won = false
    @free = true
    @aiplayer = AIPlayer.new
    @screen = createScreen [SCREEN_WIDTH, SCREEN_HEIGHT]
    @queue = EventQueue.new
    setupFont
    createPlayingField
    draw
  end

  def other player
    player == 1 ? -1 : 1
  end

  def setupFont
    TTF.setup
    @@fontHeadline = TTF.new "MgOpenModernaBold.ttf", FONTSIZE_HEADLINE
    @@fontNormal = TTF.new "MgOpenModernaBold.ttf", FONTSIZE_NORMAL
  end

  def renderFont type, text, pos
  	if type == "headline"
  		headline = @@fontHeadline.render_utf8 text, true, Color[:black]
  		headline.blit @screen, [ pos[0], pos[1] ]
  	else
  		normal = @@fontNormal.render_utf8 text, true, Color[:black]
    	normal.blit @screen, [ pos[0], pos[1] ]
    end
  end

  def createScreen size
    screen = Screen.new size, 0, [HWSURFACE, DOUBLEBUF]
    screen.title = 'Connect Four'
    screen.fill Color[:white]
  end

  def createPlayingField
  	renderFont "headline", "Connect Four!", [760, 20]
    renderFont "normal", "Spieler", [830, 80]
    renderFont "normal", "AI", [830, 140]

    @screen.draw_box_s [0, 0], [730, @screen.height], Color[:blue]
    @screen.draw_circle_s  [800,90], 20, Color[:red]
    @screen.draw_circle_s  [800,150], 20, Color[:yellow]
  end

  def draw
    arrayField = @field.field
    arrayField.each_with_index do |column,index|
      column.reverse.each_with_index do |field,row|
        distance = [(index*100)+50,(row*100)+50]
        if field == 1 then @screen.draw_circle_s  distance, 40, Color[:red] end
        if field == -1 then @screen.draw_circle_s  distance, 40, Color[:yellow] end
        if field == 0 then @screen.draw_circle_s  distance, 40, Color[:white] end
      end
    end
    @screen.update
  end

  def draw_turn player
    #renderFont "headline", "#{player} ist dran.", [760,300]
    #@screen.update
    puts "#{player} ist dran."
  end

  def drawDraw
  	renderFont "headline", "DRAW", [760, 280]
  end

  def drawWon
  	renderFont "headline", "#{@currentPlayer} won!", [750, 280]
  end

  def put_chip event
    if !@won
      @@slots.each do |index,range|
        if range.include?(event.pos[0])
          if @free
            result = @field.put_chip(index)
            if result && !@won
              @free = false
              draw
              draw_turn "AI"
              t1 = Time.new
              col = @aiplayer.move(@field.copy,-1)
              t2 = Time.new
              puts "# #{t2 - t1}"
              @field.put_chip(col)
              @free = true
              draw_turn "Spieler"
              #puts @field.field.inspect
            end
          end
        end
      end
    end
  end

  def update
    @queue.each do |event|
      #puts event
      case event
        when MouseUpEvent
          put_chip event
        when ActiveEvent
          @screen.update
        when QuitEvent
          @game_over = true
          exit
      end
    end
  end

  def checkgame
    if !@field.exists_valid_step? then drawDraw end
    if !@aiplayer.find_rows(@field,1).find {|i| i >= 4}.nil?
      @won = true
      draw_win "Spieler"
    end
    if !@aiplayer.find_rows(@field,-1).find {|i| i >= 4}.nil?
      @won = true
      draw_win "AI"
    end
  end

  def draw_win player
  	renderFont "headline", "#{player} hat gewonnen", [760, 280]
  end

  def run!
    draw_turn "Spieler"
    until @game_over do
      update
      draw
      checkgame
    end
  end

end

playingfield = Field.new 7,6, 1
game = ConnectFour.new playingfield
game.run!

