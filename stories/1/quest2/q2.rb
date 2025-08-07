ADD_REGEX = /id=(?<id>\d+)\s+left=\[(?<lp>\d+),(?<lv>[^\]]+)\]\s+right=\[(?<rp>\d+),(?<rv>[^\]]+)\]/.freeze
SWAP_REGEX = /SWAP\s+(\d+)/.freeze

def parse(lines)
  lines.map do |line|
    if (match = line.match(SWAP_REGEX))
      [:swap, match[1].to_i]
    elsif (match = line.match(ADD_REGEX))
      [:add, match[:id].to_i, [match[:lp].to_i, match[:lv]], [match[:rp].to_i, match[:rv]]]
    end
  end.compact
end

module MessageGenerator
  def generate_message_from(nodes)
    return '' if nodes.empty?

    depths = nodes.keys.group_by(&:length)
    max_count = depths.transform_values(&:count).values.max
    target_depth = depths.select { |_, paths| paths.count == max_count }.keys.min

    nodes.select { |path, _| path.length == target_depth }
         .sort
         .map { |_, data| data.last }
         .join
  end
end

class SingleTree
  include MessageGenerator
  attr_reader :nodes, :ids

  def initialize
    @nodes = {}
    @depths = Hash.new(0)
    @ids = {}
  end

  def add(id, value, symbol)
    path = ''
    path << (value < @nodes[path].first ? 'L' : 'R') while @nodes.key?(path)
    @nodes[path] = [value, symbol]
    @depths[path.length] += 1
    @ids[id] = path
  end

  def message = generate_message_from(@nodes)
end

class ConnectedTree
  include MessageGenerator

  def initialize
    @nodes = {}
    @id_map = Hash.new { |h, k| h[k] = [] }
  end

  def add(start, id, value, symbol)
    path = start.to_s
    path << (value < @nodes[path][1] ? 'L' : 'R') while @nodes.key?(path)
    @nodes[path] = [id, value, symbol]
    @id_map[id] << path
  end

  def swap(id)
    return unless @id_map[id].size == 2

    node1, node2 = @id_map[id]
    @nodes = @nodes.transform_keys do |path|
      if path.start_with?(node1)
        node2 + path.delete_prefix(node1)
      elsif path.start_with?(node2)
        node1 + path.delete_prefix(node2)
      else
        path
      end
    end

    @id_map.clear
    @nodes.each { |path, (node_id, *, _)| @id_map[node_id] << path }
  end

  def message
    generate_message_from(@nodes.select { |p, _| p.start_with?('L') }) +
    generate_message_from(@nodes.select { |p, _| p.start_with?('R') })
  end
end

def solve_quest12(commands)
  left_tree = SingleTree.new
  right_tree = SingleTree.new

  swap_nodes = lambda do |id|
    left_path = left_tree.ids[id]
    right_path = right_tree.ids[id]
    return unless left_path && right_path

    left_val = left_tree.nodes[left_path]
    right_val = right_tree.nodes[right_path]
    left_tree.nodes[left_path] = right_val
    right_tree.nodes[right_path] = left_val
  end

  commands.each do |op, id, left, right|
    case op
    when :add then
      left_tree.add(id, *left)
      right_tree.add(id, *right)
    when :swap then swap_nodes.call(id)
    end
  end
  left_tree.message + right_tree.message
end

def solve_quest3(commands)
  forest = ConnectedTree.new
  commands.each do |op, id, left, right|
    case op
    when :add then
      forest.add('L', id, *left)
      forest.add('R', id, *right)
    when :swap then forest.swap(id)
    end
  end
  forest.message
end

#files = ["samplea.txt", "sampleb.txt", "samplec.txt"]
files = ["inputa.txt", "inputb.txt", "inputc.txt"]
inputs = files.map { |f| File.read(f).strip.split("\n") rescue nil }.compact

p solve_quest12 parse inputs[0]
p solve_quest12 parse inputs[1]
p solve_quest3 parse inputs[2]
