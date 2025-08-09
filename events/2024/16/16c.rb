# frozen_string_literal: true

input = File.readlines(ARGV.length>0 ? ARGV[0] : 'sampleb.txt', chomp: true)

steps = input.first.split(',').map(&:to_i)
data = Array.new(steps.length) { [] }

input.drop(2).each do |line|
  line.scan(/.{1,4}/).each_with_index do |chunk, i|
    face = chunk.strip
    data[i] << face if face.length == 3 && !face.include?(' ')
  end
end

eyes = data.map do |wheel|
  wheel.map { |face| [face[0], face[2]] }
end

wheel_lengths = data.map(&:length)
state_coins_cache = {}

def coins_for_state(state, eyes, cache)
  return cache[state] if cache.key?(state)

  all_eyes = state.flat_map.with_index do |pos, i|
    eyes[i][pos]
  end

  counts = all_eyes.tally
  total = counts.values.sum { |cnt| cnt >= 3 ? cnt - 2 : 0 }
  cache[state] = total
end

current_max = Hash.new(-Float::INFINITY)
current_min = Hash.new(Float::INFINITY)

initial_state = Array.new(data.length, 0)
current_max[initial_state] = 0
current_min[initial_state] = 0

256.times do
  new_max = Hash.new(-Float::INFINITY)
  new_min = Hash.new(Float::INFINITY)

  current_max.each do |state, max_val|
    min_val = current_min[state]

    [-1, 0, 1].each do |delta|
      new_state = state.map.with_index do |pos, i|
        adjusted = (pos + delta) % wheel_lengths[i]
        (adjusted + steps[i]) % wheel_lengths[i]
      end

      coins = coins_for_state(new_state, eyes, state_coins_cache)

      new_max[new_state] = [new_max[new_state], max_val + coins].max
      new_min[new_state] = [new_min[new_state], min_val + coins].min
    end
  end

  current_max = new_max
  current_min = new_min
end

max_result = current_max.values.max
min_result = current_min.values.min

puts "#{max_result} #{min_result}"
