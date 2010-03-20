# Viewport constructs and methods
#
# Copyright (C) 2010 Mohammed Morsi <movitto@yahoo.com>
# Licensed under the GPLv3+ http://www.gnu.org/licenses/gpl.txt

module RAGE

# Viewport is the end user's view into the world. It is represented on
# the screen via glViewport and has a camera attached to it managing
# the viewport's projection matrix.
class Viewport

  # x,y pos, width, height
  attr_accessor :x, :y, :width, :height

  # Camera attached to viewport
  attr_accessor :camera

  # Create new Viewport with any of the following optional args,
  # * :x x coordinate of viewport on screen, defaults to 0
  # * :y y coordinate of viewport on screen, defaults to 0
  # * :width width of viewport on screen or :max, defaults to :max
  # * :height height of viewport on screen or :max, defaults to :max
  # * :camera camera to attach to viewport, if none provided one is auto created
  def initialize(args = {})
    @x = args[:x] if args.has_key? :x
    @y = args[:y] if args.has_key? :y
    @width  = args[:width]  if args.has_key? :width
    @height = args[:height] if args.has_key? :height
    @camera = args[:camera] if args.has_key? :camera

    @x = 0 if @x.nil?
    @y = 0 if @y.nil?
    @width  = :max if @width.nil?
    @height = :max if @height.nil?
    @camera = Camera.new if @camera.nil?
  end

   # Invoked during draw cycle to draw viewport and associated camera
  def draw
    w = @width  == :max ? Window.width  : @width
    h = @height == :max ? Window.height : @height
    
    Gl.glViewport(@x,@y, w, h)
    @camera.draw
  end

end

end
