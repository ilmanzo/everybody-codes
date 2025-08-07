require 'set'

class Racer
  attr_reader :total
  def initialize(actions)
    @power = 10
    @total = 0
    @actions = actions
  end
  def move(track)
    laps_total = 0
    (track.length * 11).times do |i|
      action = @actions[i % @actions.length]
      track_action = track[(i + 1) % track.length]
      if track_action == '=' || track_action == 'S'
        case action
        when '+'
          @power += 1
        when '-'
          @power -= 1
          @power = 0 if @power.negative?
        end
      else
        case track_action
        when '+'
          @power += 1
        when '-'
          @power -= 1
          @power = 0 if @power.negative?
        end
      end
      laps_total += @power
    end
    @total = laps_total * 184
  end
end

MOVES = [[1, 0], [-1, 0], [0, 1], [0, -1]].freeze

def find_winning(possible_moves, track, enemy_total, current_moves, seen)
    moves_key = current_moves.join
    return 0 if seen.include?(moves_key)

    seen.add(moves_key)

    # Base case: if all moves have been placed, check if this combination wins.
    if possible_moves.empty?
      racer = Racer.new(current_moves)
      racer.move(track)
      return racer.total > enemy_total ? 1 : 0
    end

    counter = 0
    # Recursive step: try placing each remaining move in the next slot.
    possible_moves.each_with_index do |move, i|
      new_possible_moves = possible_moves.dup
      new_possible_moves.delete_at(i)
      counter += find_winning(new_possible_moves, track, enemy_total, current_moves + [move], seen)
    end
    counter
end

actions_text = File.read("inputc.txt").strip
track_lines = File.read("trackc.txt").strip.split("\n")
enemy_actions = actions_text.split(':').last.split(',')

track = ['S', track_lines[0][1]]
prev_x, prev_y = 0, 0
current_x, current_y = 1, 0

loop do
  found_start = false
  MOVES.each do |dx, dy|
    next_x = current_x + dx
    next_y = current_y + dy
next if next_x == prev_x && next_y == prev_y
  if next_y.between?(0, track_lines.length - 1) && \
        next_x.between?(0, track_lines[next_y].length - 1) && \
        track_lines[next_y][next_x] != ' '
      if track_lines[next_y][next_x] == 'S'
        found_start = true
        break
      end
      track << track_lines[next_y][next_x]
      prev_x, prev_y = current_x, current_y
      current_x, current_y = next_x, next_y
      break
    end
  end
  break if found_start
end

puts "Track: #{track.join}"

enemy = Racer.new(enemy_actions)
enemy.move(track)
enemy_total = enemy.total

player_moves = (['+'] * 5) + (['-'] * 3) + (['='] * 3)
seen_combinations = Set.new
winning_count = find_winning(player_moves, track, enemy_total, [], seen_combinations)

puts "Found #{winning_count} winning combinations."
