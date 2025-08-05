# frozen_string_literal: true

lines = File.readlines('inputb.txt')
grids_per_row = lines[0].split.length
grids_per_column = (lines.length + 1) / 9
grids = Array.new(grids_per_row * grids_per_column) { [] }
li = 0
lines.each do |line|
  if line == "\n"
    li += grids_per_row
    next
  end
  codes = line.split
  codes.each_with_index { |code, i| grids[i + li] << code }
end

total = 0

grids.each do |g|
  grid = g.map(&:chars)
  grid_transpose = grid.transpose
  visited = []
  grid.each_with_index do |linha, i|
    linha.each_with_index do |char, k|
      next unless char == '.'
      common_chars = grid[i] & grid_transpose[k]
      common_chars.each do |c|
        if c != '.' && c != '*' && !visited.include?(c)
          visited << c
          break
        end
      end
    end
  end
  visited.each_with_index { |char, k| total += (k + 1) * (char.ord - 64) }
end

puts total
