
def phase1_pass(input)
  changed = false
  input.each_cons(2).with_index do |(a, b), i|
    if a > b
      input[i] -= 1
      input[i + 1] += 1
      changed = true
    end
  end
  changed
end

def phase2_pass(input)
  input.each_cons(2).with_index do |(a, b), i|
    if a < b
      input[i] += 1
      input[i + 1] -= 1
    end
  end
end

def part1(input)
  in_phase1 = true
  10.times do
    if in_phase1
      next if phase1_pass(input)
      in_phase1 = false
    end
    phase2_pass(input)
  end

  input.each_with_index.sum { |num, i| num * (i + 1) }
end


input = File.readlines(ARGV[0], chomp: true).map(&:to_i)

puts part1 input
