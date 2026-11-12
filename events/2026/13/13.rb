allres = File.read(ARGV[0]).split("\n\n").sum do |chunk|
  lines = chunk.lines
  hands, _, cur, move = lines.map { _1.scan(/\d+/).map(&:to_i) }
  dirs = lines[1].scan(/CW|CCW/).map { _1 == 'CW' ? 1 : -1 }
  
  l = hands.reduce(:lcm)
  cur = cur.zip(hands).map { _1 * l / _2 }
  dirs = dirs.zip(hands).map { _1 * l / _2 }

  (move + [0]).sort.each_cons(2).sum do |t1, t2|
    dv = move.zip(dirs).map { t2 <= _1 ? (t2 - t1) * _2 : 0 }
    res = cur.zip(dv).combination(2).sum do |(y, dy), (x, dx)|
      c = dx < dy ? 1 : 0
      (((x + dx) - (y + dy) - c) / l - (x - y - c) / l).abs
    end
    cur = cur.zip(dv).map { _1.sum % l }
    res
  end
end

p allres
