#!/usr/bin/env ruby

# Words to search for
words = ["THE", "OWE", "MES", "ROD", "HER", "QAQ"]

# The sentence to search in
sentence = "AWAKEN THE POWE ADORNED WITH THE FLAMES BRIGHT IRE THE FLAME SHIELDED THE HEART OF THE KINGS POWE PO WER P OWE R THERE IS THE END QAQAQ"

# Concise function to count overlapping substring occurrences using index
def count_substring_in_string(string, substring)
  count = 0
  start_pos = 0
  while (pos = string.index(substring, start_pos))
    count += 1
    start_pos = pos + 1
  end
  count
end

puts "Searching for words in the sentence:"
puts "Sentence: #{sentence}"
puts "-" * 80

# Count occurrences for each word
total_count = 0
words.each do |word|
  count = count_substring_in_string(sentence, word)
  puts "#{word}: #{count} occurrence(s)"
  total_count += count
end

puts "-" * 80
puts "Total occurrences: #{total_count}"

# Show detailed positions
puts "\nDetailed positions:"
words.each do |word|
  positions = []
  sentence.scan(/(?=#{Regexp.escape(word)})/) { positions << $~.offset(0)[0] }

  if positions.any?
    puts "#{word}: found at positions #{positions.join(', ')}"
    positions.each do |pos|
      context = sentence[[0, pos - 5].max..[sentence.length - 1, pos + word.length + 5].min]
      puts "  Position #{pos}: ...#{context.sub(word, "[#{word}]")}..."
    end
  else
    puts "#{word}: not found"
  end
  puts
end
