# RAGE DSL
#
# Copyright (C) 2010 Mohammed Morsi <movitto@yahoo.com>
# Licensed under the GPLv3+ http://www.gnu.org/licenses/gpl.txt

# Sets attributes on the Window w/ any specified arguments and then 
# invokes block w/ the Window class. Finally Window is returned.
def window(args = {}, &block)
   RAGE::Window.set_attrs args
   block.call RAGE::Window unless block.nil?
   return RAGE::Window
end

# Instantiate new viewport w/ specified args and invoke block, using
# viewport as an arg. Finally return viewport
def viewport(args = {}, &block)
   vp = RAGE::Viewport.new args
   block.call vp unless block.nil?
   return vp
end

# Load resource w/ specified args and invoke block using resource as an arg.
# Finally return resource.
def resource(args = {}, &block)
   resource = RAGE::ResourcesManager.instance.load_resource args
   block.call resource unless block.nil?
   return resource
end

# Create a RAGEi::Text instance to display on screen and invoke block
# using it as an arg. Finally return Text object
def text(txt, args = {}, &block)
  rtext = RAGE::Text.new args.merge(:text => txt)
  block.call rtext unless block.nil?
  return rtext
end

# Return input handlers manager, which can be used to register/remove
# user input handlers
def input_handlers
  RAGE::InputHandler
end

# Set attributes on Game w/ specified args and invoke block
# using Game as an arg. Finally return Game
def game(args = {}, &block)
   #Game.set_attrs(args)
   block.call RAGE::Game unless block.nil?
   return RAGE::Game
end
