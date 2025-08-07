#frozen_string_literal: true

def p1(n, exp, mod)
  score = 1
  rem_list = []
  exp.times do
    score = (score * n) % mod
    rem_list << score.to_s
  end
  rem_list.reverse.join.to_i
end

def p2(n, exp, mod)
  return 0 if mod == 1

  remainder_map = {}
  sequence = []
  score = 1

  exp.times do |k|
    val = (score * n) % mod
    if remainder_map.key?(val)
      start_index = remainder_map[val]
      cycle = sequence[start_index..]
      cycle_len = cycle.length

      rem_strings = []
      start_of_tail = [0, exp - 5].max

      (start_of_tail...exp).each do |i|
        idx_val = if i < start_index
                    sequence[i]
                  else
                    cycle[(i - start_index) % cycle_len]
                  end
        rem_strings << idx_val.to_s
      end
      return rem_strings.reverse.join.to_i
    end

    remainder_map[val] = k
    sequence << val
    score = val
  end
  sequence.last(5).map(&:to_s).reverse.join.to_i
end

def p3(n, exp, mod)
  return 0 if mod == 1

  remainder_map = {}
  sequence = []
  score = 1
  total_sum = 0

  exp.times do |k|
    val = (score * n) % mod
    if remainder_map.key?(val)
      start_index = remainder_map[val]
      cycle = sequence[start_index..]
      cycle_sum = cycle.sum
      remaining_exp = exp - k
      full_cycles = remaining_exp / cycle.length
      rest_count = remaining_exp % cycle.length

      total_sum += (full_cycles * cycle_sum) + cycle.first(rest_count).sum
      return total_sum
    end

    remainder_map[val] = k
    sequence << val
    total_sum += val
    score = val
  end

  total_sum
end

def parse(input_lines)
  input_lines.map do |line|
    tokens = line.split.to_h { |pair| pair.split('=').then { |k, v| [k, v.to_i] } }
    yield(tokens['A'], tokens['X'], tokens['M']) +
    yield(tokens['B'], tokens['Y'], tokens['M']) +
    yield(tokens['C'], tokens['Z'], tokens['M'])
  end
end

#files = ["samplea.txt", "sampleb.txt", "samplec.txt"]
files = ["inputa.txt", "inputb.txt", "inputc.txt"]

solvers = [method(:p1), method(:p2), method(:p3)]

files.zip(solvers).each do |(file, solver)|
  input = File.readlines(file, chomp: true)
  values = parse(input) do |n, exp, mod|
    solver.call(n, exp, mod)
  end
  p values.max
end
