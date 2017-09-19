
export ^ --export classes
export love

sprite=(u,l,p,r,d)->
    x,y = 0,p - 1
    if p<0 then return 16,-p - 1
    if p==d then x+=1
    if p==u then x+=2
    if p==r then x+=4
    if p==l then x+=8
    return x,y

--we need the puyo spritesheet
class Canvas
    new:=>
        @sheet = love.graphics.newImage "puyo.png"
        @sprites = {}
        for i=0,16
            @sprites[i] = {}
            for j=0,5
                @sprites[i][j] = love.graphics.newQuad i*32,j*32,32,32,640,384
        @batch = love.graphics.newSpriteBatch @sheet,(13*6 + 2)*2
        @batch\clear!
        return
    
    addBoard:(board,x,y)=>
        for i,col in pairs board.cols
            for j=1,col\nbPuyo!
                sx,sy = sprite(board\neighbors i,j)
                px,py = (i - 1)*32,352 - (j - 1)*32
                @batch\add @sprites[sx][sy],px,py
        return
    
    addBlock:(block,x,y)=>
        x1,y1 = block.x-1,block.y-1
        x2,y2 = x1,y1
        switch block.orient
            when 0 then y2+=1
            when 1 then x2-=1
            when 2 then y2-=1
            when 3 then x2+=1
        @batch\add @sprites[16][block.puyo1-1],x1*32,352 - y1*32
        @batch\add @sprites[ 0][block.puyo2-1],x2*32,352 - y2*32
        return
    
    draw:(x,y)=>
        love.graphics.setColor 30,30,60
        love.graphics.rectangle "line",x,y,192,384
        love.graphics.setColor 255,255,255
        love.graphics.draw @batch,x,y
        @batch\clear!
        return
--end Canvas