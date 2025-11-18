FILENAME=ARGV[0] || 'sample1.txt'

input = File.read(FILENAME).chars

# Define the character pairs to count.
# part1
pairs= {'a' => 'A'} 
# part2
# pairs = { 'a' => 'A', 'b' => 'B', 'c' => 'C' }

# Keep track of the counts of uppercase characters seen so far.
uppercase_counts = Hash.new(0)
total_score = 0

# Iterate through the input characters once.
input.each do |char|
  if pairs.key?(char) # It's a lowercase character we care about ('a', 'b', 'c')
    # Add the number of corresponding uppercase characters seen so far to the score.
    total_score += uppercase_counts[pairs[char]]
  elsif pairs.value?(char) # It's an uppercase character we care about ('A', 'B', 'C')
    # Increment the count for this uppercase character.
    uppercase_counts[char] += 1
  end
end

puts total_score
