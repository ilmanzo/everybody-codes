FILENAME="input3.txt"
#FILENAME="sample3.txt"
input_lines = File.read(FILENAME).lines.map(&:chomp)
names=input_lines[0].split(",")
p names
instructions=input_lines[2].split(",").map(&:chomp)
instructions.each do |instruction|
  d=-1 if instruction[0]=='L'
  d=+1 if instruction[0]=='R'
  amount=instruction[1..-1].to_i
  new = (d * amount) % names.length
  names[0], names[new] = names[new], names[0]
end

puts names[0]
