#!/usr/bin/env ruby

# sum of all-pairs shortest path lengths
def bfs(portals)
  portals.each_index.sum do |src|
    dist = Array.new(portals.size)
    dist[src] = 0
    queue = [src]
    queue.each do |p|
      portals[p].each do |q|
        next if dist[q]
        dist[q] = dist[p] + 1
        queue << q
      end
    end
    dist.sum
  end
end

def matchings(arr)
  return [[]] if arr.empty?
  first, *rest = arr
  rest.each_index.flat_map do |i|
    matchings(rest[...i] + rest[i + 1..]).map { |m| [[first, rest[i]]] + m }
  end
end

def parse_input(filename, days)
  head, *extra = File.readlines(File.join(__dir__, filename), chomp: true).reject(&:empty?)
  n = head[9..].to_i
  portals = Array.new(n) { |i| (1..days).flat_map { |j| [(i - j) % n, (i + j) % n] } }
  before = bfs(portals)
  extra.each do |line|
    a, b = line.scan(/\d+/).map { _1.to_i - 1 }
    portals[a] << b
    portals[b] << a
  end
  [portals, before]
end

# max distance-sum reduction over candidate edge sets, each tried in isolation
def best_gain(portals, before, edge_sets)
  edge_sets.map do |edges|
    edges.each { |a, b| portals[a] << b; portals[b] << a }
    gain = before - bfs(portals)
    edges.each { |a, b| portals[a].pop; portals[b].pop }
    gain
  end.max
end

def part1
  portals, before = parse_input('input1.txt', 1)
  puts before - bfs(portals)
end

def part2
  portals, before = parse_input('input2.txt', 3)
  candidates = portals.each_index.to_a.combination(2).lazy.reject { |i, j| portals[i].include?(j) }.map { [_1] }
  puts best_gain(portals, before, candidates)
end

def part3
  portals, before = parse_input('input3.txt', 3)
  step = portals.size / 8
  pairs = matchings((0..7).to_a)
  sets = step.times.flat_map do |i|
    crystals = (0...8).map { |j| (i + j * step) % portals.size }
    pairs.map { |m| m.map { |u, v| [crystals[u], crystals[v]] } }
  end
  puts best_gain(portals, before, sets)
end

part1
part2
part3
