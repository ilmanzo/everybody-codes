#all triangular numbers are also perfect squares
#

FILENAME=ARGV.length>0 ? ARGV[0] : 'sampleb.txt'
input = File.open(FILENAME, 'r').read.chomp.to_i


total_blocks=0
thickness=1

layer_width=1
AVAILABLE_BLOCKS=20240000
PRIEST=1111
#PRIEST=5
#AVAILABLE_BLOCKS=50

while total_blocks<=AVAILABLE_BLOCKS
  total_blocks+=thickness*layer_width
  p "total_blocks=#{total_blocks}, layer_width=#{layer_width}"
  thickness=(thickness*input) % PRIEST
  layer_width+=2
end
