# location module tests
#
# Copyright (C) 2010 Mohammed Morsi <movitto@yahoo.com>
# Licensed under the GPLv3+ http://www.gnu.org/licenses/gpl.txt

require File.dirname(__FILE__) + '/spec_helper'

describe Location do

  it "should default to origin coordinates" do
    loc = Location.new
    loc.x.should == 0
    loc.y.should == 0
    loc.z.should == 0
  end

  it "should accept and set location parameters" do
    mesh = MockMesh.new
    loc = Location.new :x => 1, :y => 2, :z => -5.32, :mesh => mesh
    loc.x.should == 1
    loc.y.should == 2
    loc.z.should == -5.32
    loc.mesh.should == mesh
  end

  it "should return location boundaries" do
    loc = Location.new :x => 3.14, :y => 1.59, :z => 17
    loc.boundaries.should == [3.14, 1.59, 17, 3.14, 1.59, 17]
  end

  it "should return mesh boundaries" do
    mesh = MockMesh.new
    mesh.boundaries = [10, 20, -30, 44.2, -11.11, -0.93]
    loc = Location.new :mesh => mesh, :x => 12.9, :y => -49, :z => 20.2462
    boundaries = loc.boundaries
    boundaries[0].should == 12.9 + 10
    boundaries[1].should == -49 + 20
    boundaries[2].should == 20.2462 + -30
    boundaries[3].should == 12.9 + 44.2
    boundaries[4].should == -49 + -11.11
    boundaries[5].should == 20.2462 + -0.93
  end


  it "should draw associated mesh" do
    mesh = MockMesh.new
    loc = Location.new :mesh => mesh
    loc.draw
    mesh.draw_called.should be_true
  end

end

describe LocationsManager do

  it "should clear locations" do
    LocationsManager.instance.clear
    LocationsManager.instance.locations.size.should == 0
  end

  it "should manage locations" do
    loc = Location.new
    LocationsManager.instance.clear
    LocationsManager.instance.add loc
    LocationsManager.instance.locations.size.should == 1
    LocationsManager.instance.locations.include?(loc).should be_true
  end

  it "should return boundaries of managed coordinate system" do
    loc1 = Location.new :x => 10, :y => 10, :z => 10
    loc2 = Location.new :x => -10, :y => -10, :z => -10
    loc3 = Location.new :x => 5, :y => 5, :z => 5
    loc4 = Location.new :x => 10, :y => 25, :z => -5

    LocationsManager.instance.clear
    LocationsManager.instance.add loc1
    LocationsManager.instance.add loc2
    LocationsManager.instance.add loc3
    LocationsManager.instance.add loc4

    xmax, ymax, zmax, xmin, ymin, zmin = LocationsManager.instance.boundaries
    xmax.should == 10
    ymax.should == 25
    zmax.should == 10
    xmin.should == -10
    ymin.should == -10
    zmin.should == -10
  end

  it "should return average center" do
    # TODO LocationsManager average center test
  end

  it "should return mean center" do
    # TODO LocationsManager mean center test
  end

end

class MockMesh
  attr_accessor :draw_called
  attr_accessor :location
  attr_accessor :boundaries

  def initialize
    @draw_called = false
  end

  def draw
    @draw_called = true
  end
end
