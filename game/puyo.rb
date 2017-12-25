class Puyo

public
    # we need access to those attributes to display the puyo
    attr_accessor :type, :x, :y

    # construct a new puyo to be placed in the board
    def initialize(board, type, x: nil, y: nil)
        @board = board ; @type = type
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

    # check surrounding puyos for combos
    def check

    end
end
