input = File.read(ARGV[0]).split(',').map(&:to_i)
puts "Part1:", input.to_set.sort.reverse.sum
puts "Part2:", input.to_set.sort.take(20).sum
puts "Part3:", input.tally.values.max
