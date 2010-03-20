# Input handler constructs and methods
#
# Copyright (C) 2010 Mohammed Morsi <movitto@yahoo.com>
# Licensed under the GPLv3+ http://www.gnu.org/licenses/gpl.txt

module RAGE

# FIXME turn into callback interface

# Handles and redirects user events to registered callbacks.
class InputHandler

  # Invoked during main game execution cycle to handle any SDL input events
  def self.handle(event)

     @@left_button_pressed  = false unless defined? @@left_button_pressed
     @@right_button_pressed = false unless defined? @@right_button_pressed

     case event
     when SDL::Event2::Quit
        exit

     when SDL::Event2::KeyDown
        case event.sym
        when SDL::Key::Q, SDL::Key::ESCAPE
          exit
        when SDL::Key::W
          Game.wireframe_mode= !Game.wireframe_mode
        end

     when SDL::Event::MouseMotion
        # get state of mouse buttons
        left_pressed  = ((event.state & SDL::Mouse::BUTTON_LMASK) != 0)
        right_pressed = ((event.state & SDL::Mouse::BUTTON_RMASK) != 0)

        # if left button is down, rotate camera
        if left_pressed
          xpos, ypos, zpos    = to_3d_coordinates(event.x, event.y)
          oxpos, oypos, ozpos = to_3d_coordinates(event.x-event.xrel, event.y-event.yrel)

          if xpos > oxpos
             Game.current_viewport.camera.xrotate += 1
          elsif xpos < oxpos
             Game.current_viewport.camera.xrotate -= 1
          end

          if ypos > oypos
             Game.current_viewport.camera.yrotate += 1
          elsif ypos < oypos
             Game.current_viewport.camera.yrotate -= 1
          end

          if zpos > ozpos
             Game.current_viewport.camera.zrotate += 1
          elsif zpos < ozpos
             Game.current_viewport.camera.zrotate -= 1
          end

        # if right is down pan camera
        elsif right_pressed
          if event.xrel > 0
             Game.current_viewport.camera.pos[0]    -= 1
          elsif event.xrel < 0
             Game.current_viewport.camera.pos[0]    += 1
          end

          if event.yrel > 0
             Game.current_viewport.camera.pos[1]    += 1
          elsif event.yrel < 0
             Game.current_viewport.camera.pos[1]    -= 1
          end

        end

     when SDL::Event::MouseButtonDown
        # zoom out the camera
        if event.button == 5 # wheeldown
          Game.current_viewport.camera.pos[2]    += 1
        end

     when SDL::Event::MouseButtonUp
        # zoom in the camera
        if event.button == 4 # wheel up
          Game.current_viewport.camera.pos[2]    -= 1
        end

     end 
  end
end

end
