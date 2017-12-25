class Board

public
    # we need access to the board dimensions and the puyos
    attr_accessor :width, :height, :entry, :n_types, :puyos, :block, :speed

    # construct a new board to play the game
    def initialize(n_types: 5, speed: 1, width: 6, height: 13, entry: nil)
        # dimensions of the board
        @width = width ; @height = height

        # entry points for blocks
        @entry = if entry.nil? then @width/2 else entry end

        @puyos = {}    # puyos on the board {hash => puyo}
        @block = nil   # block of two puyos
        @speed = speed # current speed of the blocks
    end

    # update the board:
    # - create new block of puyos
    # - place block of puyos
    # - manage combos
    def update

    end

    # return a list of positions that have a collider
    # (also contains the bounds of the board for convenience)
    def getCollidersForLine(line)
        line = line.to_i
        colliders = {-1 => true, @width => true}
        # for each puyo check if it is on the line and add it to the list
        @puyos.each do |pos|
            puyo = @puyos[pos]
            if puyo.y == line then colliders[puyo.x] = true end
        end
        return colliders
    end
end
