require_relative 'laser'

lines = File.readlines('input.txt')

recommendations = lines.each_slice(4).map do |arr|
 north = arr[0].chop
 position = arr[1].chop.index('X')
 south = arr[2].chop
 ConveyorBelt.new(north,south).recommended_direction(position)
end

File.open('output.txt','w') {|file| file.write(recommendations.join("\n")) }
