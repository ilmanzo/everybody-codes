SEGMENTS = {
  '0' => '012456', '1' => '25', '2' => '02346', '3' => '02356',
  '4' => '1235', '5' => '01356', '6' => '013456', '7' => '025',
  '8' => '0123456', '9' => '012356', 'A' => '012345',
  '+' => '37', '-' => '3', '=' => '89'
}.transform_values(&:chars).freeze

SEGMENT_COUNT = SEGMENTS.transform_values(&:size).freeze

PAIRS_BY_DIFF = SEGMENTS.keys.permutation(2).group_by { |x, y| [(SEGMENTS[x] - SEGMENTS[y]).size, (SEGMENTS[y] - SEGMENTS[x]).size] }

def index_pairs(pairs, from = 0) =
  Hash.new([].freeze).merge(pairs.group_by { it[from] }.transform_values { |ps| ps.map { it[1 - from] } })

ADD_ONE    = index_pairs(PAIRS_BY_DIFF[[0, 1]])
REMOVE_ONE = index_pairs(PAIRS_BY_DIFF[[0, 1]], 1)
MOVE_ONE   = index_pairs(PAIRS_BY_DIFF[[1, 1]])

def equation_holds?(line, base)
  case line.split
  in [x, op1, y, '=', z, op2, t]
    x, y, z, t = [x, y, z, t].map { it.to_i(base) }
    x.public_send(op1, y) == z.public_send(op2, t)
  else false
  end
end

def with_chars(line, edits) = line.dup.tap { |s| edits.each { |i, c| s[i] = c } }

def mutations(line)
  Enumerator.new do |out|
    out << line
    line.each_char.with_index do |c, i|
      MOVE_ONE[c].each { out << with_chars(line, i => it) }
    end
    line.each_char.with_index do |c1, i1|
      line.each_char.with_index do |c2, i2|
        next if i1 == i2
        ADD_ONE[c1].product(REMOVE_ONE[c2]) { |d1, d2| out << with_chars(line, i1 => d1, i2 => d2) }
      end
    end
  end
end

def sum_costs(filename, &check) =
  File.foreach(filename, chomp: true).filter(&check).sum { |l| l.each_char.sum { SEGMENT_COUNT.fetch(it, 0) } }

def to_base11(n) = n.to_s(11).upcase

def part1(filename) = sum_costs(filename) { equation_holds?(it, 10) }
def part2(filename) = to_base11(sum_costs(filename) { equation_holds?(it, 11) })
def part3(filename) = to_base11(sum_costs(filename) { mutations(it).any? { |m| equation_holds?(m, 11) } })

puts (1..3).map { send(:"part#{it}", "input#{it}.txt") }
