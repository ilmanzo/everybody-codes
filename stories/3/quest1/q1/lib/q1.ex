defmodule Q1 do
  @moduledoc """
  Documentation for `Q1`.
  """

  @doc """
  Converts a string where lowercase letters represent 0 and uppercase letters represent 1
  into its corresponding integer value.

  ## Examples

      iex> Q1.parse_binary("gggGgg")
      4

  """
  def parse_binary(str, acc \\ 0)

  def parse_binary(<<char, rest::binary>>, acc) when char >= ?a and char <= ?z,
    do: parse_binary(rest, acc * 2)

  def parse_binary(<<char, rest::binary>>, acc) when char >= ?A and char <= ?Z,
    do: parse_binary(rest, acc * 2 + 1)

  def parse_binary(<<>>, acc), do: acc

  defp parse_line(line) do
    [id | parts] = String.split(line, ~r/[: ]+/, trim: true)
    {String.to_integer(id), Enum.map(parts, &parse_binary/1)}
  end

  defp stream_lines(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&(&1 == ""))
  end

  @doc """
  Takes a string in the format "ID:part1 part2 part3", parses the ID,
  converts the string parts using `parse_binary/1`.
  Returns the integer ID if the middle part is strictly the greatest,
  otherwise returns 0.

  ## Examples

      iex> Q1.p1_line("2456:rrrrrr ggGgGG bbbbBB")
      2456

  """
  def p1_line(line) do
    {id, [r, g, b]} = parse_line(line)

    if(g > r and g > b, do: id, else: 0)
  end

  @doc """
  Reads a file, processes each line using `process_line/1`, and sums the returned IDs.

  ## Examples

      iex> Q1.part1("../samplea.txt")
      9166

  """
  def part1(file_path) do
    file_path
    |> stream_lines()
    |> Stream.map(&p1_line/1)
    |> Enum.sum()
  end

  @doc """
  Takes a line in the format "ID:part1 part2 part3 part4", parses it,
  and returns a tuple `{id, sum_of_first_three, fourth_component_binary}`.

  ## Examples

      iex> Q1.p2_line("2456:rrrrrr ggGgGG bbbbBB sSsSsS")
      {2456, 14, 21}

  """
  def p2_line(line) do
    {id, [r, g, b, s]} = parse_line(line)
    {id, r + g + b, s}
  end

  @doc """
  Reads a file, processes each line using `p2_line/1`, and returns the ID
  with the greatest S value. In case of a tie, the one with the lowest
  sum of the other three components wins.

  ## Examples

      iex> Q1.part2("../sampleb.txt")
      2456

  """
  def part2(file_path) do
    {id, _sum_rgb, _s} =
      file_path
      |> stream_lines()
      |> Stream.map(&p2_line/1)
      |> Enum.max_by(fn {_id, sum_rgb, s} -> {s, -sum_rgb} end)

    id
  end

  @doc """
  Evaluates a line for part 3, returning a tuple `{id, group_name}` where
  group_name is either nil (if ignored) or a string like "red-matte",
  "green-shiny", etc.

  A scale is:
  - matte if shine <= 30
  - shiny if shine >= 33
  - ignored otherwise
  - dominant color must be strictly greater than the other two colors.
  - ignored if no dominant color.

  ## Examples

      iex> Q1.p3_line("15437:rRrrRR gGGGGG BBBBBB sSSSSS")
      {15437, nil}
      iex> Q1.p3_line("94682:RrRrrR gGGggG bBBBBB ssSSSs")
      {94682, "red-matte"}
  """
  def p3_line(line) do
    {id, [r, g, b, s]} = parse_line(line)

    shine =
      cond do
        s <= 30 -> "-matte"
        s >= 33 -> "-shiny"
        true -> nil
      end

    color =
      cond do
        r > g and r > b -> "red"
        g > r and g > b -> "green"
        b > r and b > g -> "blue"
        true -> nil
      end

    group = if shine && color, do: color <> shine, else: nil

    {id, group}
  end

  @doc """
  Reads a file, evaluates each line to group scales by color and shine.
  Finds the largest group (most scales) and returns the sum of their IDs.

  ## Examples

      iex> Q1.part3("../samplec.txt")
      292320
  """
  def part3(file_path) do
    groups =
      file_path
      |> stream_lines()
      |> Stream.map(&p3_line/1)
      |> Enum.reject(fn {_id, group} -> is_nil(group) end)
      |> Enum.group_by(fn {_id, group} -> group end, fn {id, _group} -> id end)

    if map_size(groups) == 0 do
      0
    else
      groups
      |> Enum.max_by(fn {_group_name, ids} -> length(ids) end)
      |> elem(1)
      |> Enum.sum()
    end
  end
end
