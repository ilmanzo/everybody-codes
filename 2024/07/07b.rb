
def read_track_clockwise(filename)
  lines = File.readlines(filename).map(&:chomp)
  height = lines.length
  width = lines[0].length
  track = []
  (0...width).each do |col|
    track << lines[0][col]
  end
  (1...height).each do |row|
    track << lines[row][width - 1]
  end
  (width - 2).downto(0) do |col|
    track << lines[height - 1][col]
  end
  (height - 2).downto(1) do |row|
    track << lines[row][0]
  end
  track_map={'+' => +1, '=' => 0, '-' => -1, 'S' => 0}
  track.map { |t| track_map[t] }
end


class Racer
  attr_reader :total_score, :current_score, :name, :track
 def initialize(name,incrs,track)
   @name=name
   @current_score=10
   @incrs=incrs
   @incr_index=0
   @track_index=1
   @total_score=0
   @track=track
 end

 def move
   if @track[@track_index]!=0 then
     @current_score+=@track[@track_index]
   else
     @current_score+=@incrs[@incr_index]
   end
   @incr_index=(@incr_index+1) % @incrs.length
   @track_index=(@track_index+1) % @track.length
   @total_score+=@current_score
 end
end


FILENAME=ARGV.length>0 ? ARGV[0] : 'sampleb.txt'
input = File.open(FILENAME, 'r').readlines.map(&:chomp)

track=read_track_clockwise("trackb.txt")
#track=read_track_clockwise("sample_track.txt")

incr_map={'+' => +1, '=' => 0, '-' => -1}
racers=input.map do |line|
  name=line[0]
  incrs=line[2..-1].split(',').map { |i| incr_map[i] }
  puts "Parsing line: #{line}"
  puts "  Name: #{name}"
  puts "  Increments: #{incrs.inspect}"
  Racer.new name, incrs, track
end

p track

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
