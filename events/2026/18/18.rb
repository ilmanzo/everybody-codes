def fill(file)
  lo, hi = Float::INFINITY, -Float::INFINITY
  File.readlines(file).map { it.scan(/-?\d+/).map(&:to_i) }
      .sort_by { -it[1] }.push([0, 0]).each_cons(2) # [0, 0] = sentinel
      .sum { |(x, y, w), (_, ny)| lo, hi = [lo, x].min, [hi, x + (w || 1)].max; (y - ny) * (hi - lo) }
end

1.upto(3) { p fill("input#{it}.txt") }
