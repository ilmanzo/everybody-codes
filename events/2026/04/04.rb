def parse(file) = File.read(file).lines.map { it.scan(/\d+/).map(&:to_i) }

def weighted(values) = values.sort.each.with_index(1).sum { |v, i| v * i }

def part1(file) = weighted parse(file).group_by(&:first).values.map { |rows| rows.sum(&:last) }

def part2(file) = parse(file).group_by(&:first).values.map { |rows| [-rows.size, rows.sum(&:last)] }.sort
                             .each.with_index(1).sum { |(_, time), i| time * i }

def part3(file)
  total = Hash.new(0)
  stages = parse(file).sort.map { |id, quest, part, time| [quest, part, id, total[[id, quest]] += time] }.group_by { it[..1] }
  scores = Hash.new(0)
  stages.each { |(_, part), rows|
    times = rows.map(&:last)
    rows.each { |*, id, time| scores[id] += [50 * part - times.count { it < time }, 0].max }
  }
  all = scores.values
  all.sum { |score| score * (1 + all.count { it > score }) }
end

puts part1("sample1.txt"), part2("sample2.txt"), part3("sample3.txt")
puts part1("input1.txt"), part2("input2.txt"), part3("input3.txt")
