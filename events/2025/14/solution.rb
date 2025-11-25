require 'set'

FILENAME = 'input2.txt'
#FILENAME = 'sample1.txt'

lines = File.readlines(FILENAME, chomp: true)
numrows = lines.length
numcols = lines[0].length

grid = lines.each_with_index.flat_map do |line, i|
  line.chars.each_with_index.filter_map do |char, j|
    [i, j] if char == '#'
  end
end.to_set

def neighbours((x, y))
  Set[
    [x - 1, y - 1], [x - 1, y + 1],
    [x, y],
    [x + 1, y - 1], [x + 1, y + 1]
  ]
end

def evolve(grid, numrows, numcols)
  (0...numrows).flat_map do |i|
    (0...numcols).filter_map do |j|
      coord = [i, j]
      coord if (neighbours(coord) & grid).size.even?
    end
  end.to_set
end

output = (1..10).map do
  grid = evolve(grid, numrows, numcols)
  grid.size
end.sum

puts output
