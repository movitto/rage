# High level game constructs and methods
#
# Copyright (C) 2010 Mohammed Morsi <movitto@yahoo.com>
# Licensed under the GPLv3+ http://www.gnu.org/licenses/gpl.txt

require 'singleton'

module RAGE

# Manages the overall game execution, end users only need to call run
# on this class.
class Game
  include Singleton

  class_attr :current_viewport

  # Invoked during main game execution cycle to run through a single game draw operation
  def self.draw
    Window.draw

    Window.viewports.each { |vp|
      @@current_viewport = vp
      vp.draw

      # draw each location
      LocationsManager.instance.locations.each { |lm|
        lm.draw
      }
    }

    Window.refresh
  end

  # Run game and block
  def self.run
    Gl.glEnable( Gl::GL_TEXTURE_2D )
    Gl.glEnable(Gl::GL_DEPTH_TEST)
    Gl.glDepthMask(Gl::GL_TRUE)

    @@wireframe_mode = false

    while true
      while event = SDL::Event2.poll
        InputHandler.handle event
      end

      draw
      sleep 0.01
    end
     
  end

  # Bool indicating if game should be run in wireframe mode or not
  class_attr :wireframe_mode

  # Set wireframe mode on / off
  def self.wireframe_mode=(val)
    @@wireframe_mode= val
    Gl.glPolygonMode( Gl::GL_FRONT_AND_BACK, val ? Gl::GL_LINE : Gl::GL_FILL )
  end

end

end
