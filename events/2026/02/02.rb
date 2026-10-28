require 'tsort'
def o(i)
  a = Hash.new { |h, k| h[k] = [] }
  i.split.each {|r| x, y = r.split(/[<>]/) ; f, l = r.include?('<') ? [y,x] : [x,y]; a[l] << f; a[f]}
  TSort.tsort(a.method(:each_key),->(n, &blk) {a.fetch(n).each(&blk)}).join.to_i
end
p File.readlines(ARGV[0], chomp: true).reject(&:empty?).sum { o(it) }