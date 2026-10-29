#  "ISO-<base> <value>" -> [base digits, least significant first; value]
def parse(file) = File.read(file).split("\n").map { |line|
  tag, value = line.split
  [tag[/\d+\z/].chars.reverse.map(&:to_i), value.to_i]
}

# digit N of value (from the right) is weighted by bases[i mod size] ** i
def score(bases, value) = value.digits.each_with_index.sum { |d, i| bases[i % bases.size]**i * d }

def part1(file) = parse(file).sum { |bases, value| score(bases, value) }

# bruteforce:count a value only if no smaller one scores the same
def part3(file) = parse(file).sum { |bases, value|
  s = score(bases, value)
  (0...value).any? { score(bases, it) == s } ? 0 : s
}

puts part1("sample1.txt"), part1("sample2.txt"), part3("sample3.txt")
puts part1("input1.txt"), part1("input2.txt"), part3("input3.txt")
