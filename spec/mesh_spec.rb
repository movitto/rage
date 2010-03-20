# mesh module tests
#
# Copyright (C) 2010 Mohammed Morsi <movitto@yahoo.com>
# Licensed under the GPLv3+ http://www.gnu.org/licenses/gpl.txt

dir = File.expand_path(File.dirname(__FILE__))
require dir + '/spec_helper'

describe Mesh do
  before(:each) do
    @test_x3d = Loader.load "file://#{dir}/content/cube.x3d"
  end

  it "should parse x3d xsd and data" do
    mesh = Mesh.new @test_x3d
    Mesh.x3d_schema.should_not be_nil
    Mesh.x3d_schema_classes.include?(X3D).should be_true

    mesh.instance_variable_get(:@scene).should_not be_nil
    mesh.instance_variable_get(:@tf).should_not be_nil
    mesh.instance_variable_get(:@translation).should_not be_nil
    mesh.instance_variable_get(:@translation).should == [0, 0, 0]
    mesh.instance_variable_get(:@scale).should_not be_nil
    mesh.instance_variable_get(:@scale).should == [9.065643, 9.065643, 9.065643]
    mesh.instance_variable_get(:@coord_index).should_not be_nil
    mesh.instance_variable_get(:@coord_index).size.should == 24
    mesh.instance_variable_get(:@coord_index)[0...4].should == [0, 1, 2, 3]
    mesh.instance_variable_get(:@coord_point).should_not be_nil
    mesh.instance_variable_get(:@coord_point).size.should == 24
    mesh.instance_variable_get(:@coord_point)[0...3].should == [1, 1, -1]
  end

  it "should be associated with location when shown" do
    mesh = Mesh.new @test_x3d
    LocationsManager.instance.clear
    location = mesh.show_at :x => 100, :y => 100, :z => -500
    location.should_not be_nil
    location.x.should == 100
    location.y.should == 100
    location.z.should == -500
    LocationsManager.instance.locations.size.should == 1
  end

  it "should allow updates to associated location" do
    mesh = Mesh.new @test_x3d
    LocationsManager.instance.clear
    mesh.show_at :x => 100, :y => 100, :z => -500
    location = mesh.show_at :x => 200
    location.x.should == 200
    location.y.should == 100
    location.z.should == -500
    LocationsManager.instance.locations.size.should == 1
  end

  it "should return absolute center" do
    mesh = Mesh.new @test_x3d
    mesh.op_translation = [10, 20, 30]
    mesh.instance_variable_set(:@translation, [10, 20, 30])

    center = mesh.center
    center[0].should == 10 * 2
    center[1].should == 20 * 2
    center[2].should == 30 * 2
  end

  it "should return total scale" do
    mesh = Mesh.new @test_x3d
    mesh.op_scale = [10, 20, 30]
    mesh.instance_variable_set(:@scale, [10, 20, 30])

    scale = mesh.scale
    scale[0].should == 10 * 10
    scale[1].should == 20 * 20
    scale[2].should == 30 * 30
  end

  it "should return boundaries" do
    mesh = Mesh.new @test_x3d
    boundaries = mesh.boundaries
    boundaries[0...3].should == [1,1,1]
    boundaries[3...6].should == [-1,-1,-1]
  end

end
