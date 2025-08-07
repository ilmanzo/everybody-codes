defmodule Quest02 do

    def parse(input) do
      [words_line, sentence_line] = String.split(input, "\n", trim: true)
      target =
        words_line
        |> String.trim_leading("WORDS:")
        |> String.split(",", trim: true)
      [target,sentence_line]
    end

  def part1(input) do
    [target,sentence] = parse(input)
    Enum.count(target, fn t-> String.contains?(sentence, t) end)
  end

  def part2(input) do
  end

  def part3(input) do
  end

  def run do
    {:ok, input1} = File.read("input1.txt")
    IO.puts("Part1: #{part1(input1)}")

    #{:ok, input2} = File.read("input2.txt")
    #IO.puts("Part2: #{part2(input2)}")

    #{:ok, input3} = File.read("input3.txt")
    #IO.puts("Part2: #{part3(input3)}")
  end
end
