# include all rage modules
#
# Copyright (C) 2010 Mohammed Morsi <movitto@yahoo.com>
# Licensed under the GPLv3+ http://www.gnu.org/licenses/gpl.txt

lib = File.dirname(__FILE__)

$: << lib + '/rage/'

require 'rubygems'

require 'sdl'
require "gl"
require "glu"

# The Ruby Advanced Gaming Engine
module RAGE ; end

require lib + '/rage/common'
require lib + '/rage/window'
require lib + '/rage/resource'
require lib + '/rage/game'
require lib + '/rage/input'
require lib + '/rage/location'
require lib + '/rage/loader'
require lib + '/rage/color'
require lib + '/rage/mesh'
require lib + '/rage/text'
require lib + '/rage/camera'
require lib + '/rage/viewport'
require lib + '/rage/audio'
require lib + '/rage/dsl'
