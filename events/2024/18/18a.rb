require 'set'

input = File.readlines(ARGV.length>0 ? ARGV[0] : 'samplea.txt', chomp: true)
map = Set.new
p_count = 0

input.each_with_index do |line, r|
  line.chars.each_with_index do |char, c|
    next unless char == '.' || char == 'P'
    map.add([r, c])
    p_count += 1 if char == 'P'
  end
end

dirs = [[0, 1], [1, 0], [0, -1], [-1, 0]]
queue = [[1, 0]]
visited = Set.new(queue)
time = 0

while !queue.empty?
  time += 1
  next_queue = []
  queue.each do |r, c|
    dirs.each do |dr, dc|
      pos = [r + dr, c + dc]
      if map.include?(pos) && visited.add?(pos)
        next_queue << pos
        if input[pos[0]][pos[1]] == 'P'
          p_count -= 1
          if p_count.zero?
            puts time
            exit
          end
        end
      end
    end
  end
  queue = next_queue
end
