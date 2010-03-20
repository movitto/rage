# RAGE DSL
#
# Copyright (C) 2010 Mohammed Morsi <movitto@yahoo.com>
# Licensed under the GPLv3+ http://www.gnu.org/licenses/gpl.txt

# Sets attributes on the Window w/ any specified arguments and then 
# invokes block w/ the Window class. Finally Window is returned.
def window(args = {}, &block)
   Window.set_attrs args
   block.call Window unless block.nil?
   return Window
end

# Instantiate new viewport w/ specified args and invoke block, using
# viewport as an arg. Finally return viewport
def viewport(args = {}, &block)
   vp = Viewport.new args
   block.call vp unless block.nil?
   return vp
end

# Load resource w/ specified args and invoke blockm using resource as an arg.
# Finally return resource.
def resource(args = {}, &block)
   resource = ResourcesManager.instance.load_resource args
   block.call resource unless block.nil?
   return resource
end

# Set attributes on Game w/ specified args and invoke block
# using Game as an arg. Finally return Game
def game(args = {}, &block)
   #Game.set_attrs(args)
   block.call Game unless block.nil?
   return Game
end
