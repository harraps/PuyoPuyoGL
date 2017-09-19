
export ^ --export classes

--column of a game board
class Column
	new:=> @queue = {}
	puyo:(row)=> @queue[row]
	add:(puyo)=> 
		table.insert @queue,puyo
		return #@queue
	remove:(row)=>
		old = @queue[row]
		@queue[row] = -old if old~=nil
		return old
	clean:=>
		for i=12,1,-1
			if @queue[i]~=nil and @queue[i]<0
				table.remove @queue,i
		return
	filled:=> @queue[13]~=nil
	nbPuyo:=> #@queue
--end Column

--game board for a player
class Board
	new:=>
		@cols = {}
		@cols[i] = Column! for i=1,6
        return
	
	--get puyo at given position
	puyo:(col,row)=>
		return nil if col==nil or col<1 or 6<col
		return @cols[col]\puyo row
	
	add:   (col,puyo)=> @cols[col]\add    puyo
	remove:(col,row )=> @cols[col]\remove row
	clean:=>
		@cols[i]\clean! for i=1,6
		return

	filled:=>
		filled = false
		for i=1,6
			filled = true if @cols[i]\filled!
		return filled

	--neighbors of the puyo at given pos
	neighbors:(col,row)=> return (
        @puyo col,row+1),(@puyo col-1,row),(@puyo col,row),(
        @puyo col+1,row),(@puyo col,row-1)
--end Board