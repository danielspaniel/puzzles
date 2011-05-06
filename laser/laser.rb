class ConveyorBelt
  attr_reader :north_lasers, :south_lasers

  def initialize(north_lasers, south_lasers)
    raise "north and south laser banks should have same laser count" unless north_lasers.size == south_lasers.size
    @north_lasers = north_lasers.chars.map {|value| laser_in_position(value) }
    @south_lasers = south_lasers.chars.map {|value| laser_in_position(value) }
  end

  def east_hits(position)
    position.upto(north_lasers.size-1).inject(0) { |sum,index| sum += laser_hits?(index-position, index); sum }
  end

  def west_hits(position)
    position.downto(0).inject(0) { |sum,index| sum += laser_hits?(index-position, index); sum }
  end

  def recommended_direction(position)
    east_hits(position) < west_hits(position) ? "GO EAST" : "GO WEST"
  end

  private

  def laser_hits?(click, index)
    click.even? ? north_lasers[index] : south_lasers[index]
  end

  def laser_in_position(value)
    value == '|' ? 1 : 0
  end
end

