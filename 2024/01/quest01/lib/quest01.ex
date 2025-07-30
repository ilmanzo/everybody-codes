defmodule Quest01 do
  def part1(input) do
    frequencies =
      input
      |> String.graphemes()
      |> Enum.frequencies()
    b_count = Map.get(frequencies, "B", 0)
    c_count = Map.get(frequencies, "C", 0)
    b_count + c_count * 3
  end

  def part2(input) do
    input
    |> String.to_charlist()
    |> Enum.chunk_every(2)
    |> Enum.map(&pair_cost/1)
    |> Enum.sum()
  end

  def part3(input) do
    input
    |> String.to_charlist()
    |> Enum.chunk_every(3)
    |> Enum.map(&triple_cost/1)
    |> Enum.sum()
  end

  defp pair_cost(pair) do
    case pair do
      [?x, e] -> cost(e)
      [e,?x] -> cost(e)
      [e, f] -> 2 + cost(e) + cost(f)
      [e] -> cost(e)
      [] -> 0
    end
  end

  defp triple_cost(t) do
    case t do
      [?x,?x,e] -> cost(e)
      [?x,e,?x] -> cost(e)
      [e,?x,?x] -> cost(e)
      [e,f,?x] -> 2+cost(e)+cost(f)
      [e,?x,f] -> 2+cost(e)+cost(f)
      [?x,e,f] -> 2+cost(e)+cost(f)
      [e,f,g] -> 6+cost(e)+cost(f)+cost(g)
      [e] -> cost(e)
      [] -> 0
    end
  end

  defp cost(e) do
    case e do
      ?B -> 1
      ?C -> 3
      ?D -> 5
      _ -> 0
    end
  end

  def run do
    {:ok, input1} = File.read("input1.txt")
    IO.puts("Part1: #{part1(input1)}")

    {:ok, input2} = File.read("input2.txt")
    IO.puts("Part2: #{part2(input2)}")

    {:ok, input3} = File.read("input3.txt")
    IO.puts("Part2: #{part3(input3)}")
  end
end
