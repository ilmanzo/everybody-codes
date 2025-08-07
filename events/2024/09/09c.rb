# frozen_string_literal: true
require 'benchmark'

def min_stamps_table(stamps, max_amount)
  dp_table = Array.new(max_amount + 1, max_amount + 1)
  dp_table[0] = 0 # Base case: 0 coins for amount 0.
  (1..max_amount).each do |amount|
    stamps.each do |stamp|
      if stamp <= amount
        # Check if using this coin gives a better (smaller) result.
        dp_table[amount] = [dp_table[amount], 1 + dp_table[amount - stamp]].min
      end
    end
  end
  dp_table
end

def optimal_split(total_amount, stamps, max_difference)
  min_stamps = min_stamps_table(stamps, total_amount)
  best_split = []
  min_total_stamps = Float::INFINITY
  start_num1 = ((total_amount - max_difference) / 2.0).ceil
  end_num1 = (total_amount / 2.0).floor
  (start_num1..end_num1).each do |num1|
    num2 = total_amount - num1
    stamps1 = min_stamps[num1]
    stamps2 = min_stamps[num2]
    current_total_stamps = stamps1 + stamps2
    if current_total_stamps < min_total_stamps
      min_total_stamps = current_total_stamps
      best_split = [num1, num2]
      puts "New best found: Split #{best_split} -> #{min_total_stamps} stamps"
    end
  end

  # Step 3: Print the final result.
  puts "\n---"
  puts "Optimal Solution Found:"
  puts "Split: #{best_split[0]} and #{best_split[1]}"
  puts "Stamps for first part: #{min_stamps[best_split[0]]}"
  puts "Stamps for second part: #{min_stamps[best_split[1]]}"
  puts "Total minimum stamps: #{min_total_stamps}"
  min_total_stamps
end

# --- Problem Configuration ---

# The new set of available coin denominations
COIN_VALUES = [1, 3, 5, 10, 15, 16, 20, 24, 25, 30, 37, 38, 49, 50, 74, 75, 100, 101].freeze
MAX_DIFFERENCE = 100

FILENAME='inputc.txt'
input = File.open(FILENAME, 'r').readlines.map(&:to_i)


result=0
elapsed_time = Benchmark.realtime do
  result= input.map do |i|
    optimal_split(i, COIN_VALUES, MAX_DIFFERENCE)
  end.sum
end


puts "Took #{elapsed_time.round(4)} seconds."
puts
puts "Result: #{result}"
