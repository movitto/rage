# RAGE Audio Subsystem
#
# Copyright (C) 2010 Mohammed Morsi <movitto@yahoo.com>
# Licensed under the GPLv3+ http://www.gnu.org/licenses/gpl.txt

require 'singleton'

module RAGE

# TODO support different audio types

# Manages all audio operations.
# Currently uses SDL mixer to accomplish this
class Audio
  class_attr :audio_initialized

  # pass in as the :times arg to specify continuous music
  NONSTOP = -1

  def self.play(file, args = {})
    unless defined? @@audio_initialized
      @@audio_initialized = true
      # TODO allow different frequency / open options and channel allocations
      SDL::Mixer.open(22050 * 4)
      SDL::Mixer.allocate_channels(16)
    end

    audio = RAGE::Audio.new args.merge(:wave => SDL::Mixer::Wave.load(file))
    audio.play
  end

  def initialize(args = {})
    @times = 1

    @wave = args[:wave] if args.has_key? :wave
    @times = args[:times] if args.has_key? :times
  end

  def play
    @channel = SDL::Mixer.play_channel(-1, @wave, @times)
  end

  def playing?
    SDL::Mixer.play?(@channel)
  end

  def stop
    SDL::Mixer.halt(@channel)
  end

end # module Audio

end # module RAGE
