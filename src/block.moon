
export ^ --export classes

math.randomseed os.time!

--puyo colors:
-- 1: red
-- 2: green
-- 3: blue
-- 4: yellow
-- 5: purple
-- 6: pink

--get a random puyo between 1 and 6
randomPuyo=-> math.random 1,6

--block's head orientation:
-- 0: down
-- 1: right
-- 2: top
-- 3: left
--manage block of puyo
class Block
	new:(board,puyo1,puyo2)=>
		@board = board
		@puyo1,@puyo2 = puyo1 or randomPuyo!,puyo2 or randomPuyo!
		@x,@y,@orient = 3,13,0 --3rd column
		@destroy = false
        return
	
	descend:=>
		if @y==math.floor @y
			floor = @orient==2 and 2 or 1
			x2,y2 = @._xhelp @x,@y,@orient
			puyo1 = @board\puyo @x,@y-1
			puyo2 = @board\puyo x2,@y-floor
			--puyo or floor below
			if puyo1~=nil or puyo2~=nil or @y<=floor
				--destroy Block
				@destroy = true
				row1,row2 = nil
				--put puyo in board
				row2 = @board\add @x,@puyo2 if @orient==2
				row1 = @board\add @x,@puyo1
				row2 = @board\add x2,@puyo2 if @orient~=2
				--return the position of both puyo
				return @x,row1,x2,row2
		@y-= 0.5
		@correct!
		return

	move:(mov)=>
		if mov~=0
			--compute the move
			y  = math.floor @y
			x1 = @x+mov
			if     x1<1 then x1 = 1
			elseif x1>6 then x1 = 6
			--can we apply the move?
			x2 = @._xhelp x1,0,@orient
			puyo1 = @board\puyo x1,y
			puyo2 = @board\puyo x2,y
			--apply if space is free
			@x = x1 if puyo1==nil and puyo2==nil
		@correct!
		return
		
	rotate:(rot)=>
		if rot~=0
			--compute the rotation
			orient = (@orient+rot+4)%4
			--can we apply the rotation?
			y1 = math.floor @y
			y2 = if orient==2 and @y==y1
				@y-1 else -1 --> nil
			x  = @._xhelp @x,0,orient
			puyo1 = @board\puyo @x,y2
			puyo2 = @board\puyo  x,y1
			--apply if space is free
			if puyo1==nil and puyo2==nil
				@orient = orient
				--@y = y1+1 if @orient==2
		@correct!
		return
	
	correct:=>
		--push against walls
		if     @x==1 and @orient==1 then @x = 2
		elseif @x==6 and @orient==3 then @x = 5
		return

    _xhelp:(x,y,orient)-> 
        return switch orient
			when 0 then x   , y+1
            when 1 then x-1 , y
			when 2 then x   , y-1
		    when 3 then x+1 , y
		    else x,y
--end Block
