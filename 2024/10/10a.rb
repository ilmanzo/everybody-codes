grid = File.readlines('inputa.txt', chomp: true).map(&:chars)
grid_transpose = grid.transpose
visited = []
grid.each_with_index do |linha, i|
  linha.each_with_index do |char, k|
    next unless char == '.'

    common_chars = grid[i] & grid_transpose[k]
    common_chars.each do |c|
      next unless c != '.' && c != '*' && !visited.include?(c)

      grid[i][k] = c
      visited << c
      break
    end
  end
end
puts visited.join
