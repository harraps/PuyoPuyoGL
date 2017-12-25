class Board

public
    # we need access to the board dimensions and the puyos
    attr_accessor :player, :width, :height, :entry, :n_colors, :puyos, :block, :speed, :mode

    # construct a new board to play the game
    def initialize(player, n_colors: 5, speed: 1, width: 6, height: 13, entry: nil)
        @player = player

        # dimensions of the board
        @width = width ; @height = height

        # number of colors for puyos and speed of the blocks
        @n_colors = n_colors ; @speed = speed

        # entry points for blocks
        @entry = if entry.nil? then @width/2 else entry end

        @puyos = {}    # puyos on the board {hash => puyo}
        @block = nil   # block of two puyos

        # 0 : input mode
        # 1 : combo mode
        # 2 : falling mode
        @mode = 0
    end

    # update the board:
    # - create new block of puyos
    # - place block of puyos
    # - manage combos
    def update
        # comboting or falling puyos
        if    @mode == 1 then @updateCombo
        elsif @mode == 2 then @updateFalling
        # when we need to create a new block
        elsif @block.nil? then Block.new @itself
        # when we are placing a block in the board
        else
            h, d, r = @player.inputs
            @block.update h, d, r
        end
    end

    # return a list of positions that have a collider
    # (also contains the bounds of the board for convenience)
    def getCollidersForLine(line)
        line = line.to_i
        colliders = {-1 => true, @width => true}
        # for each puyo check if it is on the line and add it to the list
        @puyos.each do |pos, puyo|
            if puyo.y == line then colliders[puyo.x] = true end
        end
        return colliders
    end

    # return the list of elements in the column from bottom to top
    def getPuyosForColumn(column)
        puyos = [] # can contains nil values
        @puyos.each do |pos, puyo|
            if puyo.x == column
                puyos[@height - (puyo.x + 1)] = puyo
            end
        end
        return puyos
    end

    # add the puyo at the given position
    # set the board to falling mode
    def add(puyo, x, y)
        # set the position of the puyo
        puyo.x = x ; puyo.y = y
        @puyos[puyo.hash] = puyo
        # switch the mode of the board
        @mode = 2 # falling
    end

protected
    # update while in combo mode
    def updateCombo
        # group connected puyos by color
        groups = @groupPuyos ; groups.each do |group|
            # if the group has four puyos or more
            if group.size >= 4 then group.each do |pos, puyo|
                @puyos.delete pos
            end end
        end
        # either we continue playing or we keep comboting
        if groups.first.nil? then @mode = 0 else @mode = 2 end
    end

    # update while in falling mode
    def updateFalling
        # for each column of the board, check if we have a hole
        # then all puyos above the hole must fall
        hasHole = false # if we don't have any hole, we are done
        for c in 0...@width do puyos = @getPuyosForColumn c
            for i in 0...puyos.length do puyo = puyos[i]
                if puyo.nil? then hasHole = true
                    # we found a hole in the column
                    # all following puyos must fall
                    # TODO: make puyos fall
                end
            end
        end
    end

    # group puyos in the board
    def groupPuyos
        # create a group for each color
        colors = [] ; for c in 0...@n_colors do colors[c] = {} end

        # put each puyo of the board in the right group
        @puyos.each do |pos, puyo|
            colors[puyo.color][pos] = true
        end

        groups = {} # groups of connected puyos

        # if some groups are not connex, split them
        colors.each do |hashes|
            # iterate the graph, for each puyo remove it from the set
            # if the group contains three puyo or less we are done
            while hashes.size > 3
                # start from one puyo and aggregate by neighbors
                group = {} ; pos, puyo = hashes.first
                @aggregate hashes, group, puyo.x, puyo.y
                groups[group] = true
            end
        end
        return groups
    end

    # return hash representation of the position of the puyo
    def hash(x, y)
        return ((y & 0xFF) << 8) | (x & 0xFF)
    end

    # add puyos to the group and remove them from the set
    # recursive on neighbors
    def aggregate(set, group, x, y)
        pos = @hash x, y
        # if the puyo has already being processed
        # do not process it again
        if group[pos].nil? then puyo = set[pos]
            if puyo # if we found a puyo
                group[pos] = puyo ; set.delete pos
                # check neighbors
                @aggregate set, group, x - 1, y
                @aggregate set, group, x + 1, y
                @aggregate set, group, x, y - 1
                @aggregate set, group, x, y + 1
            end
        end
    end


end
