# frozen_string_literal: true

class SafeDigger
  def initialize(map_string, part)
    @grid = map_string.strip.lines.map { |line| line.strip.chars }
    @rows = @grid.length
    @cols = @grid[0].length
    @depths = Array.new(@rows) { Array.new(@cols) }
    @queue = []
    @part = part
  end

  def max_excavation
    initialize_depths_and_queue
    @part < 3 ? run_bfs : run_bfs2
    @depths.flatten.sum
  end

  def initialize_depths_and_queue
    @grid.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        if cell == '.'
          @depths[r][c] = 0
          @queue << [r, c]
        else # cell == '#'
          @depths[r][c] = Float::INFINITY
        end
      end
    end
  end

  def run_bfs
    head = 0
    while head < @queue.length
      r, c = @queue[head]
      head += 1
      neighbors = [[r - 1, c], [r + 1, c], [r, c - 1], [r, c + 1]]
      neighbors.each do |nr, nc|
        next unless nr.between?(0, @rows - 1) && nc.between?(0, @cols - 1)

        if @depths[r][c] + 1 < @depths[nr][nc]
          @depths[nr][nc] = @depths[r][c] + 1
          @queue << [nr, nc]
        end
      end
    end
  end

  # modified bfs with diagonal neighbors and wrap around
  def run_bfs2
    head = 0
    while head < @queue.length
      r, c = @queue[head]
      head += 1
      neighbors = [
        [r - 1, c], [r + 1, c], [r, c - 1], [r, c + 1],
        [r - 1, c - 1], [r - 1, c + 1], [r + 1, c - 1], [r + 1, c + 1]
      ]
      neighbors.each do |nr, nc|
        #wrap around
        nr = nr % @rows
        nc = nc % @cols
        if @depths[r][c] + 1 < @depths[nr][nc]
          @depths[nr][nc] = @depths[r][c] + 1
          @queue << [nr, nc]
        end
      end
    end
  end
end # class

FILENAME = 'inputc.txt'
# FILENAME="samplec.txt"
digger = SafeDigger.new(File.read(FILENAME), 3)
p digger.max_excavation
