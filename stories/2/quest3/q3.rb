def parse_input(part)
  lines = File.readlines("input#{part}.txt", encoding: 'UTF-8', chomp: true)
  dice = {}
  board = []
  lines.each do |line|
    if line.include?("=")
      a, b, c = line.split
      dice[a.to_i] = Die.new(eval(b.split('=')[1]), c.split('=')[1].to_i)
    elsif !line.empty?
      board << line.chars.map(&:to_i)
    end
  end
  [dice, board]
end

class Die
  attr_accessor :roll_number

  def initialize(faces, seed)
    @seed, @faces, @pulse = seed, faces, seed
    @roll_number, @face, @spin = 1, 0, 0
  end

  def roll
    @spin = @roll_number * @pulse
    @face = (@face + @spin) % @faces.length
    @pulse = (@pulse + @spin) % @seed
    @pulse += 1 + @roll_number + @seed
    @roll_number += 1
    @faces[@face]
  end

  def reset
    @pulse = @seed
    @roll_number = 0
    @face = 0
  end

  def to_s
    "<#{@roll_number} #{@spin} #{@faces[@face]} #{@pulse}>"
  end
end

dice = parse_input('a')[0]
total = 0
count = 0
while total < 10000
  dice.values.each do |d|
    total += d.roll
  end
  count += 1
end
puts count

dice, board = parse_input('b')
track = board[0]
dice.each_value do |die|
  i = 0
  while i < track.length
    i += 1 if die.roll == track[i]
  end
end
puts dice.keys.sort_by { |k| dice[k].roll_number }.join ','

dice, board = parse_input('c')
height = board.length
width = board[0].length

all_possible_paths = Array.new(height) { Array.new(width, false) }
cell_coordinates = (1..9).to_h { |i| [i, []] }
board.each_with_index do |row, i|
  row.each_with_index do |cell, j|
    cell_coordinates[cell] << [i, j]
  end
end

dice.each_value do |d|
  possible_paths = Array.new(height) { Array.new(width) { [0] } }
  survives = true
  while survives
    value = d.roll
    puts d
    survives = false
    cell_coordinates[value].each do |i, j|
      neighbours = possible_paths[i][j].dup
      neighbours.concat(possible_paths[i - 1][j]) if i > 0
      neighbours.concat(possible_paths[i + 1][j]) if i < height - 1
      neighbours.concat(possible_paths[i][j - 1]) if j > 0
      neighbours.concat(possible_paths[i][j + 1]) if j < width - 1
      if neighbours.include?(d.roll_number - 2)
        possible_paths[i][j] << d.roll_number - 1
        survives = true
      end
    end
  end
  board.each_with_index do |row, i|
    row.each_with_index do |_, j|
      all_possible_paths[i][j] = true if possible_paths[i][j].length > 1
    end
  end
end
puts all_possible_paths.flatten.count(true)
