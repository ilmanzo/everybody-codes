#!/usr/bin/env ruby

def runic(sentence, words)
  runicpos = Array.new(sentence.length, false)
  words.each do |w|
    start_pos = 0
    while (pos = sentence.index(w, start_pos))
      # Mark all characters of this word occurrence as true
      (pos...pos + w.length).each do |char_pos|
        runicpos[char_pos] = true if char_pos < sentence.length
      end
      start_pos = pos + 1  # Move by 1 to find overlapping matches
    end
  end
  runicpos.count(true)
end

# Test data
words = ["THE", "OWE", "MES", "ROD", "HER", "QAQ"]

sentences = [
  "AWAKEN THE POWE ADORNED WITH THE FLAMES BRIGHT IRE",
  "THE FLAME SHIELDED THE HEART OF THE KINGS",
  "POWE PO WER P OWE R",
  "THERE IS THE END",
  "QAQAQ"
]

puts "Testing runic function with example data:"
puts "Words: #{words.join(', ')}"
puts "-" * 50

total = 0
sentences.each_with_index do |sentence, i|
  forward = runic(sentence, words)
  backward = runic(sentence.reverse, words)
  line_total = forward + backward
  total += line_total

  puts "Line #{i+1}: '#{sentence}'"
  puts "  Forward: #{forward}"
  puts "  Backward: #{backward}"
  puts "  Line total: #{line_total}"
  puts
end

puts "=" * 50
puts "TOTAL: #{total}"
puts "Expected: 42"
puts "Match: #{total == 42 ? 'YES' : 'NO'}"
