class Puyo

public
    # we need access to those attributes to display the puyo
    attr_accessor :color, :x, :y

    # construct a new puyo to be placed in the board
    def initialize(board, color, x: nil, y: nil)
        @board = board ; @color = color
        if x.nil? or y.nil?
            @placed = false
        else
            @x = x ; @y = y
            @placed = true
        end
    end

    # return hash representation of the position of the puyo
    def hash
        return ((@y & 0xFF) << 8) | (@x & 0xFF)
    end

    # remove the puyo from the board
    def destroy
        @board.puyos[@hash] = nil
        return @itself
    end
end
