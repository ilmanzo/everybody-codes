defmodule ParseData do
  @doc """
  Parses data in the format "A:B,C" into a dictionary/map.

  Each line should contain a key followed by a colon, then comma-separated values.

  ## Examples

      iex> data = "A:B,C\\nB:C,A\\nC:A"
      iex> ParseData.parse_to_dict(data)
      %{"A" => ["B", "C"], "B" => ["C", "A"], "C" => ["A"]}
  """
  def parse_to_dict(data) when is_binary(data) do
    data
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(%{}, &parse_line/2)
  end

  @doc """
  Parses data from a file into a dictionary/map.

  ## Examples

      iex> ParseData.parse_file_to_dict("data.txt")
      {:ok, %{"A" => ["B", "C"], "B" => ["C", "A"], "C" => ["A"]}}
  """
  def parse_file_to_dict(filename) do
    case File.read(filename) do
      {:ok, content} -> {:ok, parse_to_dict(content)}
      {:error, reason} -> {:error, reason}
    end
  end

  defp parse_line(line, acc) do
    case String.split(line, ":", parts: 2) do
      [key, values_str] ->
        values =
          values_str
          |> String.split(",")
          |> Enum.map(&String.trim/1)

        Map.put(acc, String.trim(key), values)

      _ ->
        # Skip malformed lines
        acc
    end
  end

  @doc """
  Pretty prints the parsed dictionary.
  """
  def print_dict(dict) do
    Enum.each(dict, fn {key, values} ->
      IO.puts("#{key}: #{Enum.join(values, ", ")}")
    end)
  end
end
