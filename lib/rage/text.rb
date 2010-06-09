# Text Resource
#
# Copyright (C) 2010 Mohammed Morsi <movitto@yahoo.com>
# Licensed under the GPLv3+ http://www.gnu.org/licenses/gpl.txt

module RAGE

# Represents text to draw onscreen.
# Currently uses SDL_TTF to do so.
class Text
  attr_accessor :text

  class_attr :ttf_initialized

  def initialize(args = {})
    unless defined? @@ttf_initialized
      @@ttf_initialize = true
      SDL::TTF.init
    end

    @text = args[:text]
    @font = args[:font]
    @font_file = args[:font_file]
    @font_size = args[:font_size]

    # TODO should make use of a font bank or such so fonts can be shared, also specify default font dirs (and allow more to be added)
    @font = SDL::TTF.open(@font_file, @font_size) if @font.nil? && !@font_file.nil? && !@font_size.nil?

    # TODO allow specification of many other font attributes
  end

  # Create location w/ specified args, associated text w/ it and add it to the LocationsManager
  def show_at(args = {})
    # XXX not a huge fan of storing location interally,
    # but this is best way to do this for now
    if ! defined? @location
      args[:text] = self
      @location = Location.new(args)
      LocationsManager.instance.add @location
    else
      @location.update args
    end
    return @location
  end

  # Return current location coordinates associated w/ the text
  def coordinates
    [@location.x, @location.y, @location.z]
  end

  # Invoked during draw cycle to draw font
  def draw
    # FIXME allow font color to be set, also perhaps use other render method (solid doesn't seem to work tho)
    surface = @font.render_blended_utf8(@text, 255, 255, 255)

    texture = Gl::glGenTextures(1)[0]
    Gl::glBindTexture(Gl::GL_TEXTURE_2D, texture);

    Gl::glTexParameterf(Gl::GL_TEXTURE_2D, Gl::GL_TEXTURE_MIN_FILTER, Gl::GL_LINEAR);
    Gl::glTexParameterf(Gl::GL_TEXTURE_2D, Gl::GL_TEXTURE_MAG_FILTER, Gl::GL_LINEAR);
    Gl::glTexImage2D(Gl::GL_TEXTURE_2D, 0, Gl::GL_RGBA, surface.w, surface.h, 0, Gl::GL_RGBA, Gl::GL_UNSIGNED_BYTE, surface.pixels);

    Gl::glBegin(Gl::GL_QUADS);
    # FIXME had to switch the order of these as the text seemed backwards, look into this (used to be 00,01,11,10)
    Gl::glTexCoord2d(0, 1); Gl::glVertex3d(*coordinates)
    Gl::glTexCoord2d(1, 1); Gl::glVertex3d(@location.x+surface.w, @location.y, @location.z)
    Gl::glTexCoord2d(1, 0); Gl::glVertex3d(@location.x+surface.w, @location.y+surface.h, @location.z);
    Gl::glTexCoord2d(0, 0); Gl::glVertex3d(@location.x, @location.y+surface.h, @location.z);
    Gl::glEnd();

    Gl::glDeleteTextures([texture]);
    #SDL.SDL_FreeSurface(surface);
  end
end

end
