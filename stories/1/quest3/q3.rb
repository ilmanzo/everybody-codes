# frozen_string_literal: true

class SnailClock
  def initialize(positions)
    @snails = positions.each.with_index(1).to_h do |pos_str, i|
      [i, pos_str.scan(/\d+/).map(&:to_i)]
    end
    @clock_sizes = @snails.transform_values { |x, y| x + y - 1 }
  end

  def run_clock(days)
    final_positions = @snails.map do |id, pos|
      [id, days.times.reduce(pos) { |p, _| move_snail(id, p) }]
    end.to_h
    final_positions.values.sum { |x, y| x + 100 * y }
  end

  def reqd_days
    congruences = @snails.map { |id, (_, y)| [y, @clock_sizes[id]] }
    combine = ->((r1, m1), (r2, m2)) do
      x = r1
      x += m1 while x % m2 != r2
      [x, m1.lcm(m2)]
    end
    congruences.reduce(&combine).first - 1
  end

  private

  def move_snail(id, pos)
    x, y = pos
    y > 1 ? [x + 1, y - 1] : [1, @clock_sizes[id]]
  end
end

#files = ["samplea.txt", "sampleb.txt", "samplec.txt"]
files = ["inputa.txt", "inputb.txt", "inputc.txt"]

inputs=files.map { |f| File.readlines(f, chomp: true) rescue nil }

p SnailClock.new(inputs[0]).run_clock(100)
p SnailClock.new(inputs[1]).reqd_days
p SnailClock.new(inputs[2]).reqd_days
