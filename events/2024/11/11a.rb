FILENAME=ARGV.length>0 ? ARGV[0] : 'samplea.txt'
input=File.readlines(FILENAME, chomp: true)

rules = {}

input.each do |line|
  next if line.empty?
  parts=line.split(':')
  key = parts[0].strip
  values = parts[1].split(",").map(&:strip)
  rules[key]=values
end

rules.freeze


GENERATIONS=20

min_pop=9999999999
max_pop=0


rules.each do |termite, r|
  population=[termite]
  GENERATIONS.times do
    next_gen=[]
    population.each do |termite|
      next_gen.concat rules[termite]
    end
    population=next_gen
    #p population
  end
  result=population.length
  if result>max_pop
    max_pop=result
  elsif result<min_pop
    min_pop=result
  end
  p "max: #{max_pop}"
  p "min: #{min_pop}"
end
puts
p "max: #{max_pop}"
p "min: #{min_pop}"
