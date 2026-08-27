POSITION = /(\w+)=\[(\d+),(\d+)\]/
MOVES = /MOVES=(\w+)/
DIRECTIONS = [[-1, 0], [1, 0], [0, -1], [0, 1]]

def parse(io)
  positions, moves = {}, nil
  io.each do |line|
    if (m = POSITION.match(line))
      positions[m[1]] = [m[2].to_i, m[3].to_i]
    elsif (m = MOVES.match(line))
      moves = m[1]
    end
  end
  [positions, moves]
end

def next_position((px, py), (tx, ty)) = [(px + tx) / 2, (py + ty) / 2]

def illuminated_squares(positions, sequence)
  position = positions['START']
  seen = Set[position]
  sequence.each_char { seen << (position = next_position(position, positions[it])) }
  seen
end

def all_illuminated_squares(positions)
  position = positions['START']
  targets = %w[A B C].map { positions[it] }
  seen, to_visit = Set[position], [position]

  until to_visit.empty?
    position = to_visit.pop
    targets.each do |target|
      new_position = next_position(position, target)
      next if seen.include?(new_position)

      seen << new_position
      to_visit << new_position
    end
  end

  seen
end

positions, moves = parse(ARGF)
seen = moves ? illuminated_squares(positions, moves) : all_illuminated_squares(positions)
puts "Illuminated sky squares: #{seen.size}"

fireflies = seen.flat_map { |x, y| DIRECTIONS.map { |dx, dy| [x + dx, y + dy] } }.to_set - seen
puts "Fireflies: #{fireflies.size}"
