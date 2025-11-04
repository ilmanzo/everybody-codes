FILENAME="input2.txt"
#FILENAME="sample.txt"
input_lines = File.read(FILENAME).lines.map(&:chomp)
names=input_lines[0].split(",")
instructions=input_lines[2].split(",").map(&:chomp)
current=0
instructions.each do |instruction|
  d=-1 if instruction[0]=='L'
  d=+1 if instruction[0]=='R'
  amount=instruction[1..-1].to_i
  current+= d * amount
end

puts names[current % (names.length)]
