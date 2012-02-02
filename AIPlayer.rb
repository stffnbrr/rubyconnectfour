class AIPlayer


	INFINITY = 1.0/0
  DEPTH = 5
  FACTORMAX = {
    #1 => 0,
    2 => 1,
    3 => 100,
    4 => 100000,
	  5 => 1000000,
	  6 => 10000000,
	  7 => 100000000
  }
  FACTORMIN = {
    #1 => 0,
    2 => 10,
    3 => 500,
    4 => 100000000000000,
	  5 => 100000000000000,
	  6 => 100000000000000,
	  7 => 100000000000000
  }

  @player = nil

  def maxab(field,depth,alpha,beta)
    if depth == DEPTH || !find_rows(field,1).find {|i| i >= 4}.nil? || !find_rows(field,-1).find {|i| i >= 4}.nil?
      return eval(field)
    end
    field.valid_steps.each do |s|
      field2 = field.copy
      field2.put_chip(s)
      val = minab(field2,depth + 1,alpha,beta)
      return beta if val >= beta
      if val > alpha
        alpha = val
      end
    end
    return alpha
  end

  def minab(field,depth,alpha,beta)
    if depth == DEPTH || !find_rows(field,1).find {|i| i >= 4}.nil? || !find_rows(field,-1).find {|i| i >= 4}.nil?
      return eval(field)
    end
    field.valid_steps.each do |s|
      field2 = field.copy
      field2.put_chip(s)
      val = maxab(field2,depth + 1,alpha,beta)
      return alpha if val <= alpha
      if val < beta
        beta = val
      end
    end
    return beta
  end

#def nega_max_ab(player, depth,field, alpha, beta)
#    if depth == DEPTH || find_rows(field,player).include?(4) || find_rows(field,other(player)).include?(4)
#      return eval(field,player)
#    end
#    best =  - INFINITY
#    field.valid_steps.each do |s|
#      alpha = best if best > alpha
#      field = field.copy
#      field.put_chip(player,s)
#			val = - nega_max_ab(other(player),depth + 1,field,- beta,- alpha)
#      best = val if val > best
#      return best if best >= beta
#    end
#		best
#  end

  def player= player
    @player = player
  end

  def eval(field)
    sum1 = calc(find_rows(field,@player),FACTORMAX)
    sum2 = calc(find_rows(field,other(@player)),FACTORMIN)
    sum1 - sum2
  end

  def calc(arr,factors)
    sum = 0
    factors.each do |key,value|
      sum = sum + (arr.count(key) * value)
    end
    sum
  end

  def find_rows field, player
    result = Array.new
    columns = field.field
    # vertikal
    columns.each do |column|
      count = 0
      i = 0
      while(i < column.size) do
        if(column[i] == player)
          count = count + 1
        else
          if count != 0 && !(column[i] == player)
            result << count
          end
          count = 0
        end
        i = i + 1
      end
	    result << count if count != 0
      count = 0
    end
    #horizontal
    i_column = 0
    i_row = 0
    count = 0
    while(i_row < columns[1].size) do
      while(i_column < columns.size) do
        if(columns[i_column][i_row] == player)
          count = count + 1
        else
          if count != 0 && !(columns[i_column][i_row] == player)
            result << count
          end
          count = 0
        end
        i_column = i_column + 1
      end
	    result << count if count != 0
      count = 0
      i_column = 0
      i_row = i_row + 1
    end
    #diagonal
	  x_out = field.x_size - 1
    y_out = 1
    while x_out >= 0
      x = x_out
      y = 0
      count = 0
      while(x < field.x_size && y < field.y_size)
        if field.field[x][y] == player
          count = count + 1
        else
          result << count if count != 0
          count = 0
        end
        x = x + 1
        y = y + 1
      end
      result << count if count != 0
      count = 0
      x_out = x_out - 1
    end
    while y_out < field.y_size
      x = 0
      y = y_out
      count = 0
      while (x < field.x_size && y < field.y_size)
        if field.field[x][y] == player
          count = count + 1
        else
          result << count if count != 0
          count = 0
        end
        x = x + 1
        y = y + 1
      end
      result << count if count != 0
      count = 0
      y_out = y_out + 1
    end

    x_out = field.x_size - 1
    y_out = field.y_size - 2
    while x_out >= 0
      x = x_out
      y = field.y_size - 1
      count = 0
      while(x < field.x_size && y >= 0)
        if field.field[x][y] == player
          count = count + 1
        else
          result << count if count != 0
          count = 0
        end
        x = x + 1
        y = y - 1
      end
      result << count if count != 0
      count = 0
      x_out = x_out - 1
    end
    while y_out >= 0
      x = 0
      y = y_out
      count = 0
      while (x < field.x_size && y >= 0)
        #print "[#{x},#{y}]"
        if field.field[x][y] == player
          count = count + 1
        else
          result << count if count != 0
          count = 0
        end
        x = x + 1
        y = y - 1
      end
      result << count if count != 0
      count = 0
      y_out = y_out - 1
    end
    #puts result.inspect
    result.delete(1)
	  result
  end


  def other player
    player == 1 ? -1 : 1
  end

  def move field, player
    @player = player
    moves = field.valid_steps
    result = moves.map do |item|
      field2 = field.copy
      field2.put_chip(item)
      print "."
      minab(field2,0,-INFINITY,INFINITY)
    end
    print "\n"
    moves[result.index(result.max)]
  end


end

