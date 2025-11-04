FILENAME="input1.txt"
#FILENAME="sample.txt"
#

input_lines = File.read(FILENAME).lines.map(&:chomp)
names=input_lines[0].split(",")
instructions=input_lines[2].split(",").map(&:chomp).map! { |i| (i[0] == 'L' ? -1 : 1)*i[1..-1].to_i }

def part1(names,instructions)
  current=0
  instructions.each do |i|
    new = current + i
    new=0 if new<0
    new=names.length-1 if new > names.length-1
    current=new
  end
  puts names[current]
end

def part2(names,instructions)
  puts names[instructions.sum % (names.length)]
end

def part3(names,instructions)
  instructions.each do |i|
    new = i % names.length
    names[0], names[new] = names[new], names[0]
  end
  puts names[0]
end


part1(names.dup,instructions)
part2(names.dup,instructions)
part3(names.dup,instructions)
