input = File.read(ARGV[0]).split(',').map(&:to_i)

def isqrt_ceil(n) = Integer.sqrt(n - 1) + 1

def part1(input) = input.sum { isqrt_ceil(it)**2 - it }

def part2(input) = input.sum { [8, (it + 3) / 4 * 4].max - it }

# |1 rounds up to odd; n>=1 gives k>=2, so k>=3 for free
def part3(input) = input.sum { (isqrt_ceil(it + 1) | 1)**2 - 1 - it }

puts part1(input), part2(input), part3(input)
