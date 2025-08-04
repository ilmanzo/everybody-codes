FILENAME=ARGV.length>0 ? ARGV[0] : 'samplec.txt'
input = File.open(FILENAME, 'r').read.chomp.to_i

n = 202400000
mod = 10
hp = 10

total = 1
thickness = 1
width = 1

heights = [1]

while total < n
  thickness = ((thickness * input) % mod) + hp

  width += 2

  # Add 0 to the beginning and end of the array
  heights.unshift(0)
  heights.push(0)

  # Add the new thickness to every element in the array
  heights.map! { |h| h + thickness }

  numblocks = heights.sum

  temp = input * width

  # Iterate from the second to the second-to-last element
  (1...heights.length - 1).each do |i|
    removedblocks = (temp * heights[i]) % hp
    numblocks -= removedblocks
  end

  total = numblocks
end

puts(total - n)
