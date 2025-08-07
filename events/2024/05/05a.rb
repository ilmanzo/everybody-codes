class Grid
  attr_reader :width
  def initialize(input)
    @grid = File.open(FILENAME, 'r').readlines.map(&:chomp).map(&:split).map{|row| row.map(&:to_i)}
    @width = @grid.first.length
    @height = @grid.length+1
    @grid.push(Array.new(@width, 0))
  end

  def print
    @grid.each do |row|
      puts row.join(' ')
    end
    puts
  end

  def shout
    @grid[0].join ''
  end

  def col_height(column)
    #count the effective height of the column
    h=0
    @grid.each do |row|
      h+=1 if row[column]!=0
    end
    h
  end

  def step(column)
    clapper=@grid[0][column]
    # shift all rows up by one
    1.upto(@height-1) do |y|
      @grid[y-1][column] = @grid[y][column]
    end
    @grid[@height-1][column] = 0
    dest_col=(column+1) % @width
    h=col_height(dest_col)
    if clapper <= h
      # insert clapper at the Nth row N where N is the clapper value-1
      # and push all rows below it down by one
      (@height-1).downto(clapper-1) do |y|
        @grid[y][dest_col] = @grid[y-1][dest_col]
      end
      @grid[clapper-1][dest_col] = clapper
    else
      # insert clapper after the Nth row N where N is the clapper value-1
      # and push all rows below it down by one
      dest_row=clapper-h
      (@height-1).downto(dest_row) do |y|
        @grid[y][dest_col] = @grid[y-1][dest_col]
      end
      @grid[dest_row][dest_col] = clapper
    end
  end
end

FILENAME=ARGV.length>0 ? 'inputa.txt': 'samplea.txt'

grid=Grid.new(FILENAME)
(0..9).each do |round|
  s=(round % grid.width)
  grid.step(s)
  grid.print
  puts "step #{round+1} shout: #{grid.shout}"
end
