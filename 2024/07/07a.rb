
class Racer
  attr_reader :total_score, :name, :current_score
 def initialize(name,incrs)
   @name=name
   @current_score=10
   @incrs=incrs
   @current_index=0
   @total_score=0
 end

 def move
   @current_score+=@incrs[@current_index]
   @current_index=(@current_index+1) % @incrs.length
   @total_score+=@current_score
 end
end


FILENAME=ARGV.length>0 ? ARGV[0] : 'samplea.txt'
input = File.open(FILENAME, 'r').readlines.map(&:chomp)

incr_map={'+' => +1, '=' => 0, '-' => -1}

racers=input.map do |line|
  name=line[0]
  incrs=line[2..-1].split(',').map { |i| incr_map[i] }
  puts "Parsing line: #{line}"
  puts "  Name: #{name}"
  puts "  Increments: #{incrs.inspect}"
  Racer.new name, incrs
end

10.times do |round|
  puts "\n--- Round #{round + 1} ---"
  racers.each do |r|
    old_score = r.total_score
    r.move
    puts "#{r.name}: #{old_score} -> #{r.total_score} (current: #{r.current_score})"
  end
end


# sort the racers by total score in descending order
racers.sort_by! { |r| -r.total_score }

racers.each {|r| puts "#{r.name} = #{r.total_score}"}
