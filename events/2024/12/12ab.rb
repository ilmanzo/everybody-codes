Target = Struct.new(:x, :y, :type)

FILENAME=ARGV.length>0 ? ARGV[0] : 'sampleb.txt'
input=File.readlines(FILENAME, chomp: true)
targets = []
letters = {}
maxy = input.length - 1
input.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    if char == 'T' or char == 'H'
      targets << Target.new(x,y, char)
    elsif !['.', '=', "\n"].include?(char)
      letters[char] = [x,y ]
    end
  end
end
count = 0
targets.each do |target|
  catch(:letter_found) do
    letters.each do |letter, letter_coords|
      k = 1
      x_letter_orig, _y_letter_orig = letter_coords
      x_target,  = target.x
      while k < (x_letter_orig - x_target).abs
        y_l, x_l = letter_coords # Reset coordinates for each value of k
        y_l -= k
        x_l += 2 * k
        while y_l <= maxy
          x_l += 1
          y_l += 1
          if [x_l, y_l] == [target.x, target.y]
            path_found = true
            break
          end
        end
        if path_found
          k *= 2 if target.type == 'H'
          count += k * (letter.ord - 64)
          throw :letter_found
        end
        k += 1
      end
    end
  end
end

puts count
