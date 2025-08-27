# frozen_string_literal: true

input = File.read(ARGV.length > 0 ? ARGV[0] : 'samplea.txt')

grid, dirs = input.split("\n\n").map { |d| d.split("\n") }

def play(start_slot, sequence, grid)
  h,w = grid.length,grid[0].length
  y,x,i = -1,2*start_slot,0
  while y < h - 1
    y += 1
    next unless grid[y][x] == '*'
    x+= if sequence[i] == 'L'
           x.zero? ? +1 : -1
         else
           x == (w - 1) ? -1 : +1
         end
    i += 1
  end
  final_slot = x / 2
  [0, 2 * (final_slot + 1) - (start_slot + 1)].max
end


part1 = dirs.map.with_index do |d, i|
  play(i, d, grid)
end.sum

puts part1

n_slots = (grid[0].length + 1) / 2

part2=dirs.map do |d|
  (0...n_slots).each do |slot|
    play(slot, d, grid)
  end.max
end.sum

puts part2
