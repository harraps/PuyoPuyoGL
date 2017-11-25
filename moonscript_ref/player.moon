
export ^ --export classes

class Player
    new:(name,controls)=>
        @name = name
        @board = Board!
        @block = nil
        @manager = Manager @board
        @controls = controls
        @tick,@tack = 0,30
        @x,@tx,@r = 0,0,0
        return
    
    update:=>
        @block = nil if @block~=nil and @block.destroy
        --descend at regular rate
        if @tick >= @tack
            @tick = 0
            if @manager.dirty
                @board\clean!
                @manager.dirty = @manager\gather!
            else
                @block = Block @board if @block==nil
                @manager\manage @block\descend!
        @tick+=1

        return if @block==nil --comboting

        x,y,r = @controls\inputs!
        --move only on pressed
        if x~=@x or @tx==30
            @block\move x
            @x,@tx = x,0
        @tx+=1
        --press down to accelerate
        @tick+=5 if y==-1
        if r~=@r
            @block\rotate r
            @r = r
        return
