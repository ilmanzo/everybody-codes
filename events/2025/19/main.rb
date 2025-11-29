1.upto(3) do |j|
  i = File.open("input#{j}.txt").map { |l| l.split(',').map(&:to_i) }.group_by(&:shift)
  x, reach = i.keys.sort.inject([0, [0]]) do |(x, reach), nx|
    dx = nx - x
    [nx, i[nx].flat_map { |y, sz| (y...y+sz).select { |ny| (nx + ny).even? && reach.any? { |prev| (prev - ny).abs <= dx } } }.uniq]
  end
  puts "part #{j}: #{(x + reach.min) / 2}"
end
