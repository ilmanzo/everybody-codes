# frozen_string_literal: true


def part1(input)
  i,shoots=0,1
  while input.length>0 do
    next if ['R','G','B'][i] == input.shift
    i=(i+1)%3
    shoots+=1
  end
  shoots
end


def part23(input, repeats)
  circle = input.cycle(repeats).to_a

  left = circle.shift(circle.size / 2)
  right = circle.reverse

  shoots = 0
  bolt_iter = "RGB".bytes.cycle

  until left.empty?
    head = left.shift
    if head == bolt_iter.next
      right.pop if left.size < right.size
    end

    if left.size < right.size
      left.push(right.pop)
    end

    shoots += 1
  end

  shoots
end



input = File.read(ARGV.length > 0 ? ARGV[0] : 'samplea.txt').chomp.chars
puts part1(input)
puts part23(input,100)
