$game = nil
$gtk.reset



class Game
  attr_gtk

  def initialize
    @grid_w = 50
    @grid_h = 40


    @grid = []
	#setup and fill grid with walls
    for x in 0...@grid_w do
      @grid[x] = []
      for y in 0...@grid_h do
          @grid[x][y]= 1
      end
    end
	min_rooms = 2
	max_rooms = 10
	#setup number of rooms that will exist
	@nRooms = rand(max_rooms-min_rooms) + min_rooms
	puts "n rooms #{@nRooms}"
	rooms = []
	for room in 0...@nRooms do
		rooms[room] = make_room 8,10
	end
	
	rooms.each_with_index do |r,i| 
		(r[:x]..r[:x]+r[:w]).each do |x|
			(r[:y]..r[:y]+r[:h]).each do |y|
				@grid[x][y]= 0
			end
		end
	end
	rooms.each_with_index do |r,i| 
		if i+1 < rooms.length
			puts "how many rooms do we check #{i}"
			#r1_x = r[:x] + r[:w].div(2)
			#r2_x = rooms[i+1][:x] + rooms[i+1][:w].div(2)
			#r1_y = r[:y] + r[:h].div(2)
			#r2_y = rooms[i+1][:y] + rooms[i+1][:h].div(2)
			r1_w = r[:w].idiv(2)
			#puts "w #{r[:w]}: halfed #{r1_w}"
			r2_w = rooms[i+1][:w].idiv(2)
			r1_h = r[:h].idiv(2)
			r2_h = rooms[i+1][:h].idiv(2)

			r1_x = r[:x] #+ r1_w
			r2_x = rooms[i+1][:x]# + r2_w
			r1_y = r[:y] #+ r1_h
			r2_y = rooms[i+1][:y] #+ r2_h
			
			#this isn't looping correctly hmmm tomorrows problem
			puts "min X #{min(r1_x,r2_x)}max X: #{max(r1_x,r2_x)}"
			puts "min Y #{min(r1_y,r2_y)}max Y: #{max(r1_y,r2_y)}"
			(min(r1_x,r2_x)..max(r1_x,r2_x)).each do |x|
				(min(r1_y,r2_y)..max(r1_y,r2_y)).each do |y|
					if y == r1_y || y == r2_y || x == r1_x || x == r2_x
					#if y == r[:y] || y == rooms[i+1][:y] || x == r[:x] || x == rooms[i+1][:x]
						@grid[x][y]= 2 
						puts "x #{x} y#{y}  "
					end
				end
			end

		end
	end
	@newGrid = []
	#set new grid to prune unneeded sprites
	for x in 0...@grid_w do
      @newGrid[x] = []
      for y in 0...@grid_h do
          @newGrid[x][y]= @grid[x][y]
      end
    end
	#set up values
	for x in 0...@grid_w do
      for y in 0...@grid_h do
          if checkSurroundingTiles x,y
			#@grid[x][y] = 0
		  end
      end
    end
	
  end
  def max x,y
	return x if x > y
	else
	return y
  end
  
  def min x,y
	return x if x < y
	else
	return y
  end
  
  def checkSurroundingTiles x,y
	top = y+1 
	return false if top >=@grid_h
	bottom = y-1
	return false if bottom <= 0
	left = x-1
	return false if left <= 0
	right = x+1
	return false if right>= @grid_w
	val = @newGrid[x][top] + @newGrid[x][bottom] + @newGrid[left][y] + @newGrid[right][y] +
	@newGrid[right][bottom] + @newGrid[left][bottom] + @newGrid[left][top] + @newGrid[right][top]
	return true if val == 8
	#if @newGrid[x][top] == 1 && @newGrid[x][bottom] == 1 && @newGrid[left][y] == 1 && @newGrid[right][y] == 1
	#	return true	
	#end
	
  end
  
  def make_room max_w,max_h
	{
		x:rand(@grid_w-max_w-1)+1,
		y:rand(@grid_h-max_h-1)+1,
		w:rand(max_w)+1,
		h:rand(max_h)+1,
		#centre_x:x + w.idiv(2),
		#centre_y:y + h.idiv(2)
	}
  end
  #X and Y are grid positions not pixels
  def render_cube x, y, debug 
    boxsize = 16
    grid_x = (1280 - (@grid_w *boxsize))/2
    grid_y = (720 - ((@grid_h-2) * boxsize))/2
	if !debug
		@args.outputs.sprites << [ grid_x + (x*boxsize), (720 - grid_y)- (y* boxsize), boxsize, boxsize, "sprites/wall1.png"]
    else
		@args.outputs.sprites << [ grid_x + (x*boxsize), (720 - grid_y)- (y* boxsize), boxsize, boxsize, "sprites/debug.png"]
	end
	#@args.outputs.borders << [ grid_x + (x*boxsize), (720 - grid_y)- (y* boxsize), boxsize, boxsize, 255,255,255,255]
  end
  
  def render_grid
    for x in 0...@grid_w do
      for y in 0...@grid_h do
        render_cube x, y, false if @grid[x][y]==1
		
		render_cube x, y, true if @grid[x][y]==2
      end
    end
  end
  

  def render
	render_grid
  end

 

  def iterate
    k =args.inputs.keyboard
    
  end

  def tick
    #@grid[2][2]=1
      iterate
      render
		args.outputs.debug<< args.gtk.framerate_diagnostics_primitives
    #@current_piece_y = 5
  end

end


def tick args
  $game ||=Game.new
  $game.args = args
  $game.tick
end
