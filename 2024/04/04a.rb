FILENAME=ARGV.length>0 ? 'inputc.txt': 'samplea.txt'


input=File.open(FILENAME, 'r').readlines.map(&:chomp).map(&:to_i)

m=input.min
p input.map{|x| x-m}.sum

median = input.sort[input.size / 2]
p input.map{|x| (x-median).abs}.sum
