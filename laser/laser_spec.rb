require 'rspec'
require_relative 'laser'

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

  describe "#calculate hits" do

    describe "for #|#|#|##', '###||###" do
      before :all do
        north_data, south_data = '#|#|#|##', '###||###'
        @conveyor = ConveyorBelt.new(north_data, south_data)
      end

      it "position 3 hits west/east== 2/3" do
        @conveyor.west_hits(3).should == 2
        @conveyor.east_hits(3).should == 3
      end
    end
  end
end
