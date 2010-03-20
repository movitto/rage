# Location related constructs
#
# Copyright (C) 2010 Mohammed Morsi <movitto@yahoo.com>
# Licensed under the GPLv3+ http://www.gnu.org/licenses/gpl.txt

module RAGE

# Location w/ coordinates in the 3D system. 
# Various entities may be associated with Location to be drawn.
class Location
   # x, y, z coordinates of the location,
   attr_reader :x, :y, :z

   # Mesh which to draw at location
   attr_reader :mesh

   # TODO lights, other entities to draw at locations
   
   # Initialize Location with argument hash, which may include
   # * :x location coordinate
   # * :y location coordinate
   # * :z location coordinate
   # * :mesh resource to draw at location
   def initialize(args = {})
      @x = args.has_key?(:x) ? args[:x] : 0
      @y = args.has_key?(:y) ? args[:y] : 0
      @z = args.has_key?(:z) ? args[:z] : 0
      @mesh = args[:mesh]
   end

   # Update location w/ args, which may include
   # * :x location coordinate
   # * :y location coordinate
   # * :z location coordinate
   def update(args = {})
      @x = args[:x] if args.has_key?(:x)
      @y = args[:y] if args.has_key?(:y)
      @z = args[:z] if args.has_key?(:z)
   end

   # Return location boundaries. This is generated by determining maxima/minima
   # local coordinates of entity associated w/ location and adding those to
   # the location's coordinates. Return value is an array of six values as follows
   #   max_x, max_y, max_z, min_x, min_y, min_z
   def boundaries
     max_x = max_y = max_z = min_x = min_y = min_z = 0
     unless mesh.nil?
       max_x, max_y, max_z, min_x, min_y, min_z = mesh.boundaries
     end
     return x + max_x, y + max_y, z + max_z, x + min_x, y + min_y, z + min_z
   end


   # Invoked during draw cycle to draw location & entity associated w/ it
   def draw
     Gl.glPushMatrix();

     # translate coordinate system to location's coordinates
     Gl.glTranslatef(x, y, z)

     # draw mesh
     mesh.draw

     Gl.glPopMatrix();
   end
end

# Singleton class managing all locations
class LocationsManager
   include Singleton

   # Array of locations being managed
   attr_accessor :locations

   def initialize
     @locations = []
   end

   # Add location to be managed
   def add(location)
     @locations.push location unless @locations.include? location
   end

   # Empty the array of managed locations
   def clear
     @locations.clear
   end

   # Return the maxima and minima of the x,y,z coordinate values for all the
   # locations being managed. Return value is an array of six values as follows
   #   max_x, max_y, max_z, min_x, min_y, min_z
   # This method essentially gives you the "box" in which all locations being managed are in
   def boundaries
     max_x = max_y = max_z = min_x = min_y = min_z = 0
     @locations.each { |loc|
        locb = loc.boundaries
        max_x = locb[0] if locb[0] > max_x
        max_y = locb[1] if locb[1] > max_y
        max_z = locb[2] if locb[2] > max_z
        min_x = locb[3] if locb[3] < min_x
        min_y = locb[4] if locb[4] < min_y
        min_z = locb[5] if locb[5] < min_z
     }
     return max_x, max_y, max_z, min_x, min_y, min_z
   end

   # Return the center coordinate of location system.
   # Must specify the metric which to generate center, which may be either
   # * :avg  - compute and return bounaries averages
   # * :mean - compute and return mean of all coords
   def center(metric = :mean)
      if metric == :mean
         ls = @locations.size
         mx = my = mz = 0
         @locations.each { |lm|
            mx += lm.x / ls
            my += lm.y / ls
            mz += lm.z / ls
         }
         return mx,my,mz

      elsif metric == :avg
         b = self.boundaries
         return (b[0] + b[3]) / 2, (b[1] + b[4]) / 2, (b[2] + b[5]) / 2

      end
   end

end

# Helper method to get 3d coords cooresponding to 2d ones via OPENGL unprojection
def to_3d_coordinates(x2, y2)
  model_view = Gl.glGetDoublev Gl::GL_MODELVIEW_MATRIX
  projection = Gl.glGetDoublev Gl::GL_PROJECTION_MATRIX
  viewport   = Gl.glGetIntegerv Gl::GL_VIEWPORT
  depth      = Gl.glReadPixels x2, y2, 1, 1, Gl::GL_DEPTH_COMPONENT, Gl::GL_FLOAT
  x3, y3, z3 = Glu.gluUnProject x2, y2, depth[0], model_view, projection, viewport
  return [x3, y3, z3]
end

end
