FILENAME="inputb.txt"
#FILENAME="sampleb.txt"
input_lines = File.read(FILENAME).lines
words = input_lines[0].split(':')[1].strip.split(',')

#search also the reversed words
words += words.map(&:reverse)

def runic(sentence, words)
  isrunic=Array.new(sentence.length, false)
  words.each do |w|
    startpos=0
    while(i=sentence.index(w,startpos))
      (i...(i+w.length)).each do |char_pos|
        isrunic[char_pos] = 1 if char_pos < sentence.length
      end
      startpos=i+1
    end
  end
  isrunic.count(1)
end

sentences=input_lines[2..-1].map(&:strip)

p sentences.map { |s| runic(s, words) }.sum
