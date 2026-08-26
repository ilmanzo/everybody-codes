def step_back?(cur, len, seen) = len <= cur && !seen.include?(cur - len)

def part1(seqs)
  seqs.sum { |seq|
    cur, seen = 0, Set.new
    seq.each { |len| seen << cur; cur += step_back?(cur, len, seen) ? -len : len }
    cur
  }
end

def part2(seqs)
  seqs.sum { |seq|
    cur, seen = 0, Set.new
    seq.each { |len|
      seen << cur
      if step_back?(cur, len, seen)
        cur -= len
      else
        cur += len
        cur += 1 while seen.include?(cur)
      end
    }
    cur
  }
end

Arc = Data.define(:from, :to, :side) do
  # Data.new coerces positional args to kwargs, so initialize must take kwargs too
  def initialize(from:, to:, side:)
    from, to = [from, to].minmax
    super(from:, to:, side:)
  end

  def jumps_in?(jf, jt, js) = side == js && !(jf >= from && jf <= to) && jt > from && jt < to
  def jumps_out?(jf, jt, js) = side == js && jf > from && jf < to && !(jt >= from && jt <= to)
  def crosses?(jf, jt, js) = jumps_in?(jf, jt, js) || jumps_out?(jf, jt, js)
end

def next_position(cur, len, side, seen, arcs)
  nxt = cur
  return nxt - len if len <= nxt && !seen.include?(nxt - len) && arcs.none? { it.crosses?(cur, nxt - len, side) }

  nxt += len
  loop do
    return nil if arcs.any? { it.jumps_out?(cur, nxt, side) }
    return nxt unless seen.include?(nxt) || arcs.any? { it.jumps_in?(cur, nxt, side) }

    nxt += 1
  end
end

def part3(seqs)
  seqs.sum { |seq|
    side, arcs, cur, seen = :under, [], 0, Set.new
    seq.each { |len|
      seen << cur
      nxt = next_position(cur, len, side, seen, arcs)
      next unless nxt

      arcs << Arc.new(cur, nxt, side)
      side = side == :under ? :over : :under
      cur = nxt
    }
    cur
  }
end

def parse(file) = File.readlines(file, chomp: true).map { it.split(',').map(&:to_i) }

{ part1: 'inputa.txt', part2: 'inputb.txt', part3: 'inputc.txt' }.each { |m, f| puts send(m, parse(f)) }
