class LaserBank < Struct.new(:north, :south)
  def hit_for_click(click)
    click.even? ? north : south
  end
end

class ConveyorBelt
  attr_reader :lasers

  def initialize(north_data, south_data)
    raise "north and south laser banks should have same laser count" unless north_data.size == south_data.size
    @lasers = []
    0.upto(north_data.size-1) do |n|
      @lasers.push LaserBank.new(
          laser_in_position(north_data.slice(n)),
          laser_in_position(south_data.slice(n))
      )
    end
  end

  def east_hits(position)
    position.upto(lasers.size-1).collect { |index| laser_hits?(index-position, index) }.compact.size
  end

  def west_hits(position)
    position.downto(0).collect { |index| laser_hits?(index-position, index) }.compact.size
  end

  def recommended_direction(position)
    east_hits(position) < west_hits(position) ? "GO EAST" : "GO WEST"
  end

  private

  def laser_hits?(click, index)
    lasers[index].hit_for_click(click) or nil
  end

  def laser_in_position(value)
    value == '|'
  end
end

