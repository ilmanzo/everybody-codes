#  "ISO-<base> <value>" -> [base digits, least significant first; value]
def parse(file) = File.read(file).split("\n").map { |line|
  tag, value = line.split
  [tag[/\d+\z/].chars.reverse.map(&:to_i), value.to_i]
}

# digit N of value (from the right) is weighted by bases[i mod size] ** i
def score(bases, value) = value.digits.each_with_index.sum { |d, i| bases[i % bases.size]**i * d }

def part1(file) = parse(file).sum { |bases, value| score(bases, value) }

# a: bruteforce, count a value only if no smaller one scores the same (~44s)
def part3a(file) = parse(file).sum { |bases, value|
   s = score(bases, value)
   (0...value).any? { score(bases, it) == s } ? 0 : s
}

# b: (~0.3s): count a value only if it is the smallest number with its score:
# build that number greedily from the top digit, smallest digit whose remainder lower digits can still reach
def part3b(file) = parse(file).sum { |bases, value|
  s = score(bases, value)
  w = Array.new(value.digits.size) { |i| bases[i % bases.size]**i }
  reach = Hash.new { |h, (i, r)| h[[i, r]] = i < 0 ? r.zero? : r > 9 * w[..i].sum ? false : (0..9).any? { r >= it * w[i] && h[[i - 1, r - it * w[i]]] } }
  min, r = 0, s
  (w.size - 1).downto(0) { |i|
    d = (0..9).find { r >= it * w[i] && reach[[i - 1, r - it * w[i]]] }
    min, r = min * 10 + d, r - d * w[i]
  }
  min == value ? s : 0
}

#puts part1("sample1.txt"), part1("sample2.txt"), part3a("sample3.txt")
#puts part1("input1.txt"), part1("input2.txt"), part3a("input3.txt")
#puts part3b("input3.txt")
