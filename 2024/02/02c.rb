# frozen_string_literal: true
class RunicWordSearch
  # Search directions: [delta_row, delta_col]
  DIRECTIONS = {
    :up => [-1, 0],
    :down => [1, 0],
    :left => [0, -1],
    :right => [0, 1]
  }.freeze

  def initialize(words, grid)
    @grid = grid
    @words = words
    @rows = grid.length
    @cols = grid[0].length
    @found_coords = Set.new
  end

  # Main method to solve the puzzle.
  def solve
    puts "Searching for runic words"
    p @words
    puts "on the scale armour..."
    p @grid
    puts "---"

    @words.each { |word| find_all_occurrences(word) }

    #puts @found_coords.to_a.sort.inspect
    puts "Total number of scales: #{@found_coords.size}"
  end

  private

  # Finds all occurrences of a single word and adds their coordinates to the set.
  def find_all_occurrences(word)
    is_word_found = false
    @rows.times do |r|
      @cols.times do |c|
        DIRECTIONS.each do |name, (dr, dc)|
          path = trace_path(word, r, c, dr, dc)
          next unless path
          #puts "Found '#{word}' going #{name} from [#{r}, #{c}]"
          @found_coords.merge(path)
          is_word_found = true
        end
      end
    end
    puts "Could not find '#{word}'." unless is_word_found
    puts "---"
  end

  # Traces a word from a starting point in a specific direction.
  # Returns an array of coordinates if found, otherwise nil.
  def trace_path(word, start_r, start_c, dr, dc)
    path = []
    word.length.times do |i|
      row = start_r + i * dr
      # The modulo operator handles horizontal wraparound for both left and right.
      col = (start_c + i * dc) % @cols
      # Check for vertical out-of-bounds or a character mismatch.
      return nil if row.negative? || row >= @rows || @grid[row][col] != word[i]
      path << [row, col]
    end
    path
  end
end

FILENAME="inputc.txt"
#FILENAME="samplec.txt"
input_lines = File.read(FILENAME).lines
words = input_lines[0].split(':')[1].strip.split(',')
grid = input_lines[2..].map { |line| line.strip.split('') }
solver = RunicWordSearch.new(words,grid)
solver.solve
