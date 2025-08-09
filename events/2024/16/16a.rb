input = File.readlines(ARGV.length>0 ? ARGV[0] : 'samplea.txt', chomp: true)

numbers = input.first.split(',')
face_cats = input.drop(2)

data = Array.new(numbers.length) { [] }

face_cats.each do |cat|
  cat.scan(/.{1,4}/).each_with_index do |chunk, i|
    face = chunk[0, 3]
    data[i] << face if face != '   ' && !data[i].nil?
  end
end

selected_cats = numbers.map.with_index do |num_str, i|
  column = data[i]
  next if column.nil? || column.empty?
  index = (num_str.to_i * 100) % column.length
  column[index]
end

puts selected_cats.compact.join(' ')
