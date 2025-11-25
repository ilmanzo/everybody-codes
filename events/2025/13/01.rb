e,o=ARGF.read.split.map(&:to_i).partition.with_index{|_,n|n.even?};w=[1]+e+o.reverse;p w[2025%w.length]
