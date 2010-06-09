# Window constructs and methods
#
# Copyright (C) 2010 Mohammed Morsi <movitto@yahoo.com>
# Licensed under the GPLv3+ http://www.gnu.org/licenses/gpl.txt

module RAGE

# Manages game window
class Window

  # Screen width / height, and handle
  class_attr :width, :height, :screen

  # Viewports arrays
  class_attr :viewports

  # Set attributes on window, which may include
  # * :width
  # * :height
  def self.set_attrs(args = {})
     @@width  = args[:width]  if args.has_key? :width
     @@height = args[:height] if args.has_key? :height

     @@viewports = []
  end

  # Create a viewport using specified args and add it to
  def self.create_viewport(vp_args = {}, &block)
    vp = viewport vp_args, &block
    viewports << vp
    return vp
  end

  # Display window
  def self.show
    SDL.init(SDL::INIT_VIDEO)
    SDL.setGLAttr(SDL::GL_DOUBLEBUFFER,1)
    # make sdl pickup keys being held as multiple key events (TODO make this optional)
    SDL::Key.enableKeyRepeat(SDL::Key::DEFAULT_REPEAT_DELAY / 2, SDL::Key::DEFAULT_REPEAT_INTERVAL / 2)
    @@screen = SDL::Screen.open(width,height,32,SDL::OPENGL | SDL::SWSURFACE)

    @@black = ResourcesManager.instance.load_resource :type => :color, :color => [0,0,0]
  end

  # Invoked during draw cycle to draw window
  def self.draw
    Gl.glClear(Gl::GL_COLOR_BUFFER_BIT | Gl::GL_DEPTH_BUFFER_BIT)
    @@screen.fill_rect(0,0,width,height,@@black.color)
  end

  # Invoked during draw cycle to refresh window
  def self.refresh
    @@screen.update_rect(0,0,0,0)
    SDL.GLSwapBuffers()
    #Gl.glFlush();
  end

end

end
