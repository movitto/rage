# Resources constructs and methods
#
# Copyright (C) 2010 Mohammed Morsi <movitto@yahoo.com>
# Licensed under the GPLv3+ http://www.gnu.org/licenses/gpl.txt

require 'singleton'

module RAGE

# Singleton class managing all RAGE resources.
# Resources should be loaded here instead as opposed to creating them manually
# so as to mantain a central management repository during game execution.
class ResourcesManager
 include Singleton

  # Hash of ids -> resources we are managing
  attr_accessor :resources

  def initialize
    @resources = {}
  end

  # Load resource from specified args and add to manager. Args may include
  # * :type type of resource to load
  # * :id   unique identifier to give resource
  # * :uri  uri of resource if appropriate
  # * :color resource color if appropriate
  def load_resource(args = {})
    type = args[:type]
    id = args[:id]

    resource = nil

    if type == :mesh
      uri  = args[:uri]
      data = Loader.load uri
      resource = Mesh.new(data)
    elsif type == :text
      text = args[:text]
      resource = Text.new(:text => text)
    elsif type == :color
      color = args[:color]
      resource = Color.new(:rgb => color)
    # elsif other resource types
    end

    @resources[id] = resource
    return resource
  end
end

end
