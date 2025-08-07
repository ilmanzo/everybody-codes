# Read track.txt file in clockwise manner into a linear array

def read_track_clockwise(filename)
  lines = File.readlines(filename).map(&:chomp)

  # Get dimensions
  height = lines.length
  width = lines[0].length

  track = []

  # 1. Top row: left to right (starting from S)
  (0...width).each do |col|
    track << lines[0][col]
  end

  # 2. Right column: top to bottom (skip the corner we already added)
  (1...height).each do |row|
    track << lines[row][width - 1]
  end

  # 3. Bottom row: right to left (skip the corner we already added)
  (width - 2).downto(0) do |col|
    track << lines[height - 1][col]
  end

  # 4. Left column: bottom to top (skip both corners we already added)
  (height - 2).downto(1) do |row|
    track << lines[row][0]
  end

  track
end

# Read the track
FILENAME = ARGV.length > 0 ? ARGV[0] : 'track.txt'
clockwise_track = read_track_clockwise(FILENAME)

# Print the result
puts "Clockwise track array:"
puts clockwise_track.join('')
puts
puts "Length: #{clockwise_track.length}"
puts
puts "First 20 characters: #{clockwise_track[0...20].join('')}"
