def parse(notes)
  tokens = notes.lines(chomp: true).flat_map { it.split('=') }
  width, height = tokens[1].to_i, tokens[3].to_i
  horizontal, vertical = tokens[5], tokens[7]
  [width, height, (horizontal * 2).chars.map(&:to_i), (vertical * 2).chars.map(&:to_i)]
end

def solve(width, height, horizontal, vertical)
  rows, columns = horizontal.size, vertical.size
  row_parity = 0
  total = [0, 0]

  (0...[rows, height].min).each do |y|
    row_parity ^= 1 if y.positive? && horizontal[y].zero?
    column_parity = 0

    next unless horizontal[y] == horizontal[(y + 1) % rows]

    (0...[columns, width].min).each do |x|
      column_parity ^= 1 if x.positive? && vertical[x] == y % 2
      next unless horizontal[y] == x % 2 && vertical[x] == y % 2 && vertical[(x + 1) % columns] == y % 2

      total[row_parity ^ column_parity] += (width - x).ceildiv(columns) * (height - y).ceildiv(rows)
    end
  end

  total
end

def part1(totals) = totals.sum
def part2(totals) = totals.max
def part3(totals) = totals.max

%i[part1 part2 part3].zip(ARGV).each do |m, f|
  puts send(m, solve(*parse(File.read(f))))
end
