class ConveyorBelt
  attr_reader :north_lasers, :south_lasers

  def initialize(north_lasers, south_lasers)
    raise "north and south laser banks should have same laser count" unless north_lasers.size == south_lasers.size
    @north_lasers = north_lasers.chars.map {|value| laser_in_position(value) }
    @south_lasers = south_lasers.chars.map {|value| laser_in_position(value) }
  end

  def east_hits(position)
    hit_count position..(north_lasers.size-1), position
  end

  def west_hits(position)
    hit_count 0..position, position
  end

  def recommended_direction(position)
    east_hits(position) < west_hits(position) ? "GO EAST" : "GO WEST"
  end

  private

  def hit_count(arr_range, position)
    arr_range.inject(0) { |sum,index| sum += laser_hits?(index-position, index); sum }
  end

  def laser_hits?(click, index)
    click.even? ? north_lasers[index] : south_lasers[index]
  end

  def laser_in_position(value)
    value == '|' ? 1 : 0
  end
end

