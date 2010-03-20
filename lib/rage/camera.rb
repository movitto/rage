# Camera constructs and methods
#
# Copyright (C) 2010 Mohammed Morsi <movitto@yahoo.com>
# Licensed under the GPLv3+ http://www.gnu.org/licenses/gpl.txt

module RAGE

# Camera is the end user's view into the world.
# It is instantiated as part of a viewport and controls the
# projection matrix through which the 3D world is viewed.
class Camera

   # Projection matrix to use, managed internally
   attr_accessor :projection

   # Camera coordinates
   attr_accessor :pos

   # Degrees to rotate camera around x,y,z axes
   attr_accessor :xrotate, :yrotate, :zrotate

   def initialize
     # FIXME this needs to be parameterized more

     # initialize projection params from window
     depth = (Window.width + Window.height)/4
     @projection = [45, Window.width / Window.height, 1, depth]

     # initialize lookat params
     @pos    = [0, 0, 1]

     # initial rotation params
     @xrotate, @yrotate, @zrotate = 0,0,0
   end

   # Invoked during draw cycle to setup projection matrix
   def draw
    # setup projection matrix
    Gl.glMatrixMode(Gl::GL_PROJECTION)
    Gl.glLoadIdentity

    # TODO at some point make this more modular, allowing user to
    # select glOrtho or glFrustrum w/ configurable params
    Glu.gluPerspective(*@projection)

    Gl.glMatrixMode(Gl::GL_MODELVIEW)
    Gl.glLoadIdentity

    # translate the world by inverse camera position
    Gl.glTranslatef *(@pos.collect { |p| p * -1 })

    # rotate camera according to params
    Gl.glRotatef(@xrotate, 1, 0, 0)
    Gl.glRotatef(@yrotate, 0, 1, 0)
    Gl.glRotatef(@zrotate, 0, 0, 1)
   end
end

end
