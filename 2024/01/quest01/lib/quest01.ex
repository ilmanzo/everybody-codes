defmodule Quest01 do

  def part1(input) do
    frequencies =
       input
       |> String.graphemes()
       |> Enum.frequencies()
     b_count = Map.get(frequencies, "B", 0)
     c_count = Map.get(frequencies, "C", 0)
    b_count+c_count*3
  end


  def part2(input) do
    input
    |> String.to_charlist()
    |> Enum.chunk_every(2)
    |> Enum.map(&pair_cost/1)
    |> Enum.sum()
  end

  defp pair_cost(pair) do
    case pair do
      [enemy, enemy] -> (enemy_cost(enemy) + 1) * 2
      [enemy1, enemy2] -> enemy_cost(enemy1) + enemy_cost(enemy2)
      # A single leftover creature at the end of the string.
      [enemy] -> enemy_cost(enemy)
      # Should not happen with valid input, but good to have a default.
      [] ->
        0
    end
  end

  # Private helper to get the base cost of a single enemy.
  defp enemy_cost('A'), do: 0
  defp enemy_cost('B'), do: 1
  defp enemy_cost('C'), do: 3
  defp enemy_cost('D'), do: 5
  defp enemy_cost('x'), do: 0
  defp enemy_cost(_), do: 0 # Any unknown character costs 0.

  def run do
    {:ok, input1} = File.read("input1.txt")
    IO.puts "Part1: #{part1(input1)}"

    {:ok, input2} = File.read("input2.txt")
    IO.puts "Part2: #{part2(input2)}"
  end
end
