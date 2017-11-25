
export ^
export love

class ControlKeyBoard

    new:=>
        @up    , @down  = "up"   , "down"
        @left  , @right = "left" , "right"
        @anti , @clock  = "z"    , "x"
    
    inputs:=>
        x,y,r = 0,0,0
        if love.keyboard.isDown @up    then y+=1
        if love.keyboard.isDown @down  then y-=1
        if love.keyboard.isDown @left  then x-=1
        if love.keyboard.isDown @right then x+=1
        if love.keyboard.isDown @clock then r-=1
        if love.keyboard.isDown @anti  then r+=1
        return x,y,r

average=(x)->
    return if x >  0.5 then  1
    elseif    x < -0.5 then -1
    else 0

class ControlJoystick

    new:(id)=>
        @joy = love.joystick.getJoysticks![id]
        @axisX = "leftx"
        @axisY = "lefty"
        @clock,@anti = 1,0
    
    inputs:=>
        x = average @joy\getAxis @axisX
        y = average @joy\getAxis @axisY
        r = 0
        if @joy\isDown @clock then r-=1
        if @joy\isDown @anti  then r+=1
        return x,y,r