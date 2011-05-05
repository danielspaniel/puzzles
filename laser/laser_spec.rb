require 'rspec'
require_relative 'laser'

RSpec.configure do |config|
  config.mock_with :rr
end

RSpec::Matchers.define :have_laser_values do |expected|
  match do |actual|
    [actual.north, actual.south] == expected
  end
end

describe LaserBank do

  describe "#hit_for_click" do
    it "returns a hit when click is even and north has laser" do
      LaserBank.new(true, false).hit_for_click(0).should == true
    end

    it "returns NO hit when click is even and north has NO laser" do
      LaserBank.new(false, false).hit_for_click(0).should == false
    end

    it "hits when click is odd and south has laser" do
      LaserBank.new(false, true).hit_for_click(1).should == true
    end

    it "returns NO hit when click is odd and north has NO laser" do
      LaserBank.new(false, false).hit_for_click(1).should == false
    end
  end

end

describe ConveyorBelt do

  describe "making new" do

    before :all do
      north_data, south_data = 'x|x', 'xx|'
      @conveyor = ConveyorBelt.new(north_data, south_data)
    end

    it "assembles correct number of LaserBanks" do
      @conveyor.lasers.size.should == 3
    end

    it "initializes laser banks correctly" do
      @lasers = @conveyor.lasers
      @lasers[0].should have_laser_values [false, false]
      @lasers[1].should have_laser_values [true, false]
      @lasers[2].should have_laser_values [false, true]
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

      it "position 5 hits west/east == 2/3" do
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
