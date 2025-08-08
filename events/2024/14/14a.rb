input=File.read(ARGV.length>0 ? ARGV[0] : 'samplea.txt')
base, moves=0, input.split(',').map(&:strip).select { |m| m[0] == 'U' || m[0] == 'D' }.map { |m| m[0] == 'U' ? m[1..-1].to_i : -m[1..-1].to_i }
p moves.map { |m| base += m }.max
