#stamps=[1, 3, 5, 10].freeze
stamps= [1, 3, 5, 10, 15, 16, 20, 24, 25, 30].freeze


def min_stamps(stamps, amount)
  dp = Array.new(amount + 1, amount + 1)
  dp[0] = 0
  (1..amount).each do |a|
    stamps.each do |stamp|
      if stamp <= a
        dp[a] = [dp[a], 1 + dp[a - stamp]].min
      end
    end
  end
  dp[amount] > amount ? -1 : dp[amount]
end


FILENAME=ARGV.length>0 ? ARGV[0] : 'samplea.txt'
input = File.open(FILENAME, 'r').readlines.map(&:to_i)

result= input.map do |i|
  min_stamps(stamps, i)
end.sum

p result
