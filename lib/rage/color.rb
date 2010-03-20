# Color Resource
#
# Copyright (C) 2010 Mohammed Morsi <movitto@yahoo.com>
# Licensed under the GPLv3+ http://www.gnu.org/licenses/gpl.txt

module RAGE

# Represents a rgb color in the framework
class Color
  attr_accessor :color

  def initialize(args = {})
    rgb = args[:rgb]
    @color = Window.screen.format.map_rgb(*rgb)
  end
end

end
