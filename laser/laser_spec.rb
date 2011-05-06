require 'rspec'
require_relative 'laser'

RSpec.configure do |config|
  config.mock_with :rr
end

describe ConveyorBelt do

  describe "making new" do

    before :all do
      north_data, south_data = 'x|x', 'xx|'
      @conveyor = ConveyorBelt.new(north_data, south_data)
    end

    it "initializes laser banks correctly" do
      @conveyor.north_lasers.should == [0, 1, 0]
      @conveyor.south_lasers.should == [0, 0, 1]
    end
  end

  describe "calculating hits" do

    describe "for sample data => #|#|#|##', '###||###" do
      before :all do
        north_data = '#|#|#|##'
        south_data = '###||###'
        @conveyor = ConveyorBelt.new(north_data, south_data)
      end

      it "position 3 hits west/east == 2/3" do
        position = 3
        @conveyor.west_hits(position).should == 2
        @conveyor.east_hits(position).should == 3
      end

      it "position 5 hits west/east == 4/1" do
        position = 5
        @conveyor.west_hits(position).should == 4
        @conveyor.east_hits(position).should == 1
      end
    end

  end

  describe "#recommended_direction at any position" do
    before :each do
      @position = 3
      @conveyor = ConveyorBelt.new('', '')
    end

    it "should be WEST when EAST has more hits" do
      mock(@conveyor).west_hits(@position) { 2 }
      mock(@conveyor).east_hits(@position) { 3 }
      @conveyor.recommended_direction(@position).should == "GO WEST"
    end

    it "should be EAST when WEST has more hits" do
      mock(@conveyor).west_hits(@position) { 3 }
      mock(@conveyor).east_hits(@position) { 2 }
      @conveyor.recommended_direction(@position).should == "GO EAST"
    end

    it "should be WEST when EAST has same number of hits" do
      mock(@conveyor).west_hits(@position) { 3 }
      mock(@conveyor).east_hits(@position) { 3 }
      @conveyor.recommended_direction(@position).should == "GO WEST"
    end
  end

end
