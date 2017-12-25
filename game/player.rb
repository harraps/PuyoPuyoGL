class Player

public
    attr_accessor :key_up, :key_down, :key_left, :key_right, :key_rotate_left, :key_rotate_right
    # create a new player with a set of inputs
    def initialize(key_up, key_down, key_left, key_right, key_rotate_left, key_rotate_right)
        @key_up   = key_up   ; @key_down  = key_down
        @key_left = key_left ; @key_right = key_right
        @key_rotate_left  = key_rotate_left
        @key_rotate_right = key_rotate_right
    end

    # return inputs pressed by the player
    def inputs
        h = 0 ; r = 0
        if @pressed @key_left         then h -= 1 end
        if @pressed @key_right        then h += 1 end
        if @pressed @key_rotate_left  then r -= 1 end
        if @pressed @key_rotate_right then r += 1 end
        return h, @pressed(@key_down), r
    end

protected
    # return true if the key is pressed
    def pressed(key)
        # TODO
        return false
    end
end
