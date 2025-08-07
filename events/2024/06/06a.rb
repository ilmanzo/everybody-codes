def find_odd_length_path(input)
  tree = {}
  root = input.first.split(':').first

  input.each do |line|
    next if line.start_with? 'BUG'
    parent, children_str = line.split(':', 2)
    tree[parent] = children_str ? children_str.split(',') : []
  end

  all_paths = []

  find_paths_dfs = ->(node, current_path) do
    children = tree[node]
    return if children.nil?
    children.each do |child|
      if child == '@'
        all_paths << current_path + '/'+ '@'
      else
        find_paths_dfs.call(child, current_path +'/'+ child)
      end
    end
  end
  find_paths_dfs.call(root, root)
  return "No paths were found." if all_paths.empty?
  paths_by_length = all_paths.group_by(&:length)
  odd_group = paths_by_length.values.find { |group| group.length == 1 }
  if odd_group
    return odd_group.first # Return the path string itself
  else
    return "Could not find a single path with a unique length."
  end
end

FILENAME=ARGV.length>0 ? ARGV[0] : 'samplea.txt'
input = File.open(FILENAME, 'r').readlines.map(&:chomp)
puts find_odd_length_path(input)
