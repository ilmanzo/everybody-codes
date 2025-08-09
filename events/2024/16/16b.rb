# frozen_string_literal: true

def get_coin(cat_face) = cat_face.chars.tally.values.sum { |num| num >= 3 ? num -2 : 0 }

input = File.readlines(ARGV.length>0 ? ARGV[0] : 'sampleb.txt', chomp: true)

original_numbers = input.first.split(',').map(&:to_i)
data = Array.new(original_numbers.length) { [] }
input.drop(2).each do |line|
  line.scan(/.{1,4}/).each_with_index do |chunk, i|
    face = chunk[0, 3]
    if data[i] && face.length == 3 && !face.include?(' ')
      data[i] << face
    end
  end
end

numbers = Array.new(original_numbers.length, 0)
total_coins = 0
coins_history = {}
total_iterations = 202420242024

(0...total_iterations).each do |j|
  cat_face_parts = []
  current_indexes = []

  numbers.each_with_index do |_, i|
    numbers[i] = (numbers[i] + original_numbers[i]) % data[i].length
    face = data[i][numbers[i]]
    cat_face_parts << face[0] + face[2]
    current_indexes << numbers[i]
  end

  if coins_history.key?(current_indexes)
    start_iteration, = coins_history[current_indexes]
    cycle_length = j - start_iteration

    num_divisions = total_iterations / cycle_length
    remainder = total_iterations % cycle_length

    total_coins *= num_divisions

    target_state = coins_history.find { |_, (iter, _)| iter == remainder - 1 }
    total_coins += target_state.last.last if target_state

    break
  else
    cat_face = cat_face_parts.join
    total_coins += get_coin(cat_face)
    coins_history[current_indexes] = [j, total_coins]
  end
end

p total_coins
