
export ^ --export classes
export love

class Window
    new:=>
        love.window.setIcon love.image.newImageData "puyo_icon.png"
        love.window.setTitle "ぷよぷよ löve"
        love.window.setMode 600,400,{resizable: true}
        @resize love.graphics.getWidth!,love.graphics.getHeight!
        return
    
    resize:(width,height)=>
        @x = math.floor 0.5*(width  - 192)
	    @y = math.floor 0.5*(height - 384)
        return
--end Window

export window = Window!

love.resize=(width,height)->
    window\resize width,height
    return