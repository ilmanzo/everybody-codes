# Function to parse transformation rules and apply them
class TransformationParser
  # Parses transformation rules from data string into a hash
  # Each line describes how one element transforms into others
  # Format: "A:B,C" means A transforms into B and C
  #
  # Example:
  #   data = "A:B,C\nB:C,A\nC:A"
  #   parser = TransformationParser.new
  #   rules = parser.parse_rules(data)
  #   # => {"A" => ["B", "C"], "B" => ["C", "A"], "C" => ["A"]}
  def parse_rules(data)
    rules = {}

    data.strip.split("\n").each do |line|
      next if line.strip.empty?

      parts = line.split(":", 2)
      next if parts.length != 2

      source = parts[0].strip
      targets = parts[1].split(",").map(&:strip)

      rules[source] = targets
    end

    rules
  end

  # Parses transformation rules from a file
  def parse_rules_from_file(filename)
    content = File.read(filename)
    parse_rules(content)
  rescue => e
    raise "Error reading file #{filename}: #{e.message}"
  end

  # Applies one step of transformation to a collection of elements
  # Returns the new collection after transformation
  def apply_transformation(elements, rules)
    new_elements = []

    elements.each do |element|
      if rules.key?(element)
        new_elements.concat(rules[element])
      else
        # If no rule exists, element remains unchanged
        new_elements << element
      end
    end

    new_elements
  end

  # Applies multiple steps of transformation
  def apply_n_transformations(initial_elements, rules, steps)
    current = initial_elements.dup

    (1..steps).each do |step|
      current = apply_transformation(current, rules)
      puts "Step #{step}: #{current.join(', ')}" if block_given?
      yield(step, current) if block_given?
    end

    current
  end

  # Counts occurrences of each element after transformations
  def count_elements_after_transformations(initial_elements, rules, steps)
    final_elements = apply_n_transformations(initial_elements, rules, steps)

    counts = Hash.new(0)
    final_elements.each { |element| counts[element] += 1 }
    counts
  end

  # Pretty prints the transformation rules
  def print_rules(rules)
    puts "Transformation Rules:"
    rules.each do |source, targets|
      puts "  #{source} → #{targets.join(', ')}"
    end
  end

  # Simulates the transformation process with detailed output
  def simulate(initial_elements, rules, steps)
    puts "Initial: #{initial_elements.join(', ')}"
    print_rules(rules)
    puts "\nSimulation:"

    current = initial_elements.dup

    (1..steps).each do |step|
      current = apply_transformation(current, rules)
      puts "Step #{step}: #{current.join(', ')} (Count: #{current.length})"
    end

    current
  end
end

# Standalone functions (if you prefer not to use a class)
def parse_transformation_rules(data)
  rules = {}

  data.strip.split("\n").each do |line|
    next if line.strip.empty?

    parts = line.split(":", 2)
    next if parts.length != 2

    source = parts[0].strip
    targets = parts[1].split(",").map(&:strip)

    rules[source] = targets
  end

  rules
end

def apply_transformation_step(elements, rules)
  new_elements = []

  elements.each do |element|
    if rules.key?(element)
      new_elements.concat(rules[element])
    else
      new_elements << element
    end
  end

  new_elements
end

# Example usage:
if __FILE__ == $0
  # Sample transformation rules
  sample_data = "A:B,C\nB:C,A\nC:A"

  parser = TransformationParser.new
  rules = parser.parse_rules(sample_data)

  puts "=== Transformation System ==="
  parser.print_rules(rules)

  # Start with a single A
  initial = ["A"]
  puts "\n=== Simulation starting with A ==="
  result = parser.simulate(initial, rules, 5)

  puts "\n=== Element counts after 5 steps ==="
  counts = parser.count_elements_after_transformations(["A"], rules, 5)
  counts.each { |element, count| puts "#{element}: #{count}" }

  # Example with multiple starting elements
  puts "\n=== Starting with multiple elements ==="
  initial_multiple = ["A", "B"]
  result2 = parser.simulate(initial_multiple, rules, 3)
end
