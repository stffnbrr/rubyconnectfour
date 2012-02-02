class Field
  EMPTY = 0
  MAXCONST = 1
  MINCONST = -1
  TARGET = 4

  attr_reader :field, :x_size, :y_size, :player

  def initialize x_size, y_size, beginner
    @won = false
    @player = beginner
    @x_size = x_size
    @y_size = y_size
    @field = Array.new
    x_size.times do |i|
      temp = Array.new
      y_size.times {|b| temp[b] = EMPTY}
      @field[i] = temp
    end
  end
  
  def == field
    @field == field.field
  end

  def data
    @field
  end

  def field= field
    @field = field
  end

  def copy
    field_temp = Marshal.load( Marshal.dump(@field) )
    new_field = Field.new(x_size,y_size,@player)
    new_field.field=(field_temp)
    new_field
  end
  
  def other player
    player == 1 ? -1 : 1
  end

  def put_chip column
    row = valid_step column
    if (!row) then return false end
    @field[column][row] = @player
    @player = other(@player)
    true
  end

  def valid_step column
    if ( !0..@x_size.include?(column) ) then return false end
    @y_size.times do |row|
      if ( @field[column][row] == EMPTY ) then return row end
    end
    false
  end

  def valid_steps
  	validSteps = Array.new
  	x_size.times do |column|
  		validSteps << column if @field[column].last == 0
  	end
  	validSteps
  end

  def exists_valid_step?
    field = @field
    field.flatten.include?(EMPTY)
  end

  def to_s
    @field.inspect
  end


end

