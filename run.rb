# http://www.diatomenterprises.com/different-sides-of-ruby-development-opengl/
# https://github.com/hoxxep/webgl-ray-tracing-demo
# https://math.stackexchange.com/questions/51539/a-math-function-that-draws-water-droplet-shape

require 'opengl'
require 'glu'
require 'gosu'

require_relative './objects/axis'

include Gl, Glu

class Window < Gosu::Window

  def initialize
    super 800, 600
    self.caption = "Diatom's OpenGL Tutorial"
  end

  def update
  end

  def draw
    gl do
      glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
      glPushMatrix
        glTranslated(width/2, height/2, 0)
        Axis.draw(100, 100, 100)
      glPopMatrix
    end
  end

  def button_down(id)
    exit if id == Gosu::KbEscape
  end
end

Window.new.show
