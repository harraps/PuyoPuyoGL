class Block

public
    # a block has 4 orientations:
    # - 0 : head down  ; body up
    # - 1 : head right ; body left
    # - 2 : head up    ; body down
    # - 3 : head left  ; body right
    attr_accessor :board, :puyos, :x, :y, :orient, :speed

    # create a new block to be placed on the board
    def initialize(board)
        @board = board   # board where the block is being placed

        # orientation of the block
        # specify in which direction the block is rotating
        # and what the orientation we wish to reach
        @orient = 0 ; @rotating = 0 ; @target = 0

        # position of the head of the block
        @x = @board.entry ; @y = @board.height - 1

        # the two puyos in the block, the first one is the head
        p0 = Puyo.new @board, rand(@board.n_types)
        p1 = Puyo.new @board, rand(@board.n_types)
        @puyos = [p0, p1]

        # register the block as the current block of the board
        @board.block = @itself
    end

    # move the block in the board based on the provided inputs
    # (h and r must be normalized)
    def update(h, d, r)
        # when the block is rotating, we must change the orientation progressively
        if @rotating != 0 then @updateRotation
        # otherwise we can update the block based on inputs
        else updateInputs h, d, r end
    end

protected
    # update the block while rotating
    def updateRotation
        @orient += @rotating * @speed / 180
        # check if we passed by the target
        if
            (@rotating < 0 and @orient <= @target) or
            (@rotating > 0 and @orient >= @target)
            # once the target reached, stop rotating
            @rotating = 0
            @orient = @target
        end
    end

    # update the block based on inputs
    # cannot be used when rotating
    def updateInputs(h, d, r)
        # we only need the list of colliders of the lowest line
        y = if @orient == 2 then @y - 1 else @y end

        # check horizontal colliders if we are moving on the horizontal axis
        if h != 0
            # recover all of the colliders for the lowest line of the block
            colls = @board.getCollidersForLine y

            # check that horizontal movements are possible
            # moving toward the left/right but collider on the left/right => we cannot move
            if
                (@orient == 1 and h < 0 and colls[@x - 2]) or
                (@orient == 3 and h > 0 and colls[@x + 2]) or
                (h < 0 and colls[@x - 1]) or
                (h > 0 and colls[@x + 1]) then h = 0 end
            @x += h # apply horizontal movements
        end

        # we can move downward only if we are not rotating
        # we can control if we want to move downward faster
        if d or false # TODO: check if block is moving down at this update

            # check for colliders directly under the block only when we are at an int position
            if @y.to_i == @y
                colls = @board.getCollidersForLine y - 1

                # check that the block is not stopped by a collider
                if
                    (@orient == 1 and colls[@x - 1]) or
                    (@orient == 3 and colls[@x + 1]) or
                    colls[@x] then @destroy
                else @y -= 0.5 end # no collider -> move down
            else @y -= 0.5 end # not integer position -> move down
        end

        # check if rotation are possible
        if r != 0
            # we only need to check for colliders around the head
            colls1 = @board.getCollidersForLine @y
            colls2 = @board.getCollidersForLine @y - 1
            # we know that puyo are affected by gravity, because of that,
            # we do not need to check for puyos above the head of the block
            c_C = colls2[@x]
            c_L = colls1[@x - 1]
            c_R = colls1[@x + 1]
            c_LC = c_L or colls2[@x - 1] or c_C
            c_RC = c_R or colls2[@x + 1] or c_C
            # |    |    |    |  ;  +   -|+   -
            # | L  | P  | R  |  ;  _____P_____
            # | LC | C  | RC |  ;  -   +|-   +
            if not (
                (@orient == 0 and ((0 > r and c_R )  or  (0 < r and c_L ))) or
                (@orient == 2 and ((r < 0 and c_LC)  or  (r > 0 and c_RC))) or
                (@orient == 1 and  (r < 0 and c_LC)) or
                (@orient == 3 and  (r > 0 and c_RC)) )
                # if our movements are not blocked by other puyos
                @rotating = r
                @target = (@orient + r + 4) % 4
            end
        end
    end

    # place the puyos of the block in the board
    def destroy
        # destroy the block
        @board.block = nil

        # place the puyos of the block in the board
        x = if @orient == 1 then @x - 1 elsif @orient == 3 then @x + 1 else @x end
        y = if @orient == 2 then @y - 1 elsif @orient == 0 then @y + 1 else @y end
        @board.add @puyos[0], @x, @y
        @board.add @puyos[1],  x,  y # adapt coordinates based on orientation
    end

end
