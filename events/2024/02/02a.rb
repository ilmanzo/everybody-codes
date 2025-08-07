FILENAME="input1.txt"
#FILENAME="sample.txt"
input_lines = File.read(FILENAME).lines
words = input_lines[0].split(':')[1].strip.split(',')

sentence=input_lines[2].strip
# count how many times each word appears in the sentence
p words.map {|w| sentence.scan(w).count}.sum
