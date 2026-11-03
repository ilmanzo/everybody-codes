require "minitest/autorun"

def parse(file) = File.read(file).scan(/^(\w+):(.+)$/).flat_map { |from, tos| tos.split(',').map { [from, it] } }

def reachable(edges, start)
  graph = edges.group_by(&:first).transform_values { |es| es.map(&:last) }
  seen = Set[start]
  todo = [start]
  while (node = todo.pop)
    graph.fetch(node, []).each { todo << it if seen.add?(it) }
  end
  seen
end

def part1(file) = reachable(parse(file), 'NULL').size - 1

def part2(file) = reachable(parse(file).map(&:reverse), 'NULL').size - 1

def part3(file)
  edges = parse(file).map(&:reverse)
  %w[NULLv1 NULLv2 NULLv3].flat_map { reachable(edges, it).to_a }.tally.count { |_, n| n > 1 }
end

class TestQuest06 < Minitest::Test
  def test_part1 = assert_equal 7, part1("sample1.txt")
  def test_part2 = assert_equal 6, part2("sample1.txt")
  def test_part3 = assert_equal 3, part3("sample3.txt")
end

puts part1("input1.txt"), part2("input2.txt"), part3("input3.txt")
