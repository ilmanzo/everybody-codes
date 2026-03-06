defmodule Q3 do
  def match_both?(%{color: c, shape: s}, %{color: c, shape: s}), do: true
  def match_both?(_, _), do: false

  def match_one?(%{color: c}, %{color: c}), do: true
  def match_one?(%{shape: s}, %{shape: s}), do: true
  def match_one?(_, _), do: false

  def parse_line(line) do
    [id_part, plug_part, left_part, right_part | _] = String.split(line, ", ")

    parse_conn = fn str ->
      [_, val] = String.split(str, "=")
      [c, s] = String.split(val, " ")
      %{color: String.to_atom(c), shape: String.to_atom(s)}
    end

    [_, id_str] = String.split(id_part, "=")

    %{
      id: String.to_integer(id_str),
      plug: parse_conn.(plug_part),
      left_socket: parse_conn.(left_part),
      right_socket: parse_conn.(right_part),
      left: nil,
      right: nil
    }
  end

  # Part 1 & 2: Simple recursive insertion (DFS)
  def insert(tree, node, match_fn) do
    # Try Left
    res_left =
      if tree.left do
        insert(tree.left, node, match_fn)
      else
        if match_fn.(tree.left_socket, node.plug), do: {:ok, node}, else: :error
      end

    case res_left do
      {:ok, new_child} ->
        {:ok, %{tree | left: new_child}}

      :error ->
        # Try Right
        res_right =
          if tree.right do
            insert(tree.right, node, match_fn)
          else
            if match_fn.(tree.right_socket, node.plug), do: {:ok, node}, else: :error
          end

        case res_right do
          {:ok, new_child} -> {:ok, %{tree | right: new_child}}
          :error -> :error
        end
    end
  end

  # Part 3: Complex insertion with swapping
  # Returns: {new_tree, current_node, status} where status is :inserted or :continue
  def insert_p3(tree, node) do
    # 1. Process Left Branch
    {tree, node, status} = process_branch(tree, node, :left)

    if status == :inserted do
      {tree, node, :inserted}
    else
      # 2. Process Right Branch (with potentially updated tree and node)
      process_branch(tree, node, :right)
    end
  end

  defp process_branch(tree, node, side) do
    socket = if side == :left, do: tree.left_socket, else: tree.right_socket
    child = if side == :left, do: tree.left, else: tree.right

    if child do
      # Check for swap condition: Existing child is weak match, new node is strong match
      if !match_both?(socket, child.plug) and
           match_both?(socket, node.plug) do
        # Swap: Insert new node here, old child becomes the node to insert
        new_tree = Map.put(tree, side, node)
        {new_tree, child, :continue}
      else
        # Recurse into child
        {new_child, new_node, status} = insert_p3(child, node)
        new_tree = Map.put(tree, side, new_child)
        {new_tree, new_node, status}
      end
    else
      # Empty socket: Check weak match
      if match_one?(socket, node.plug) do
        new_tree = Map.put(tree, side, node)
        {new_tree, node, :inserted}
      else
        {tree, node, :continue}
      end
    end
  end

  # Main loop for Part 3: Retries insertion with displaced nodes until success
  def add_node_p3(tree, node) do
    case insert_p3(tree, node) do
      {new_tree, _, :inserted} -> new_tree
      {new_tree, displaced, :continue} -> add_node_p3(new_tree, displaced)
    end
  end

  def traverse(nil, acc), do: acc

  def traverse(node, acc) do
    traverse(node.left, [node.id | traverse(node.right, acc)])
  end

  def solve(file, part) do
    input = File.read!(file)

    tree =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce(nil, fn line, tree ->
        node = parse_line(line)

        if is_nil(tree) do
          node
        else
          case part do
            :p1 ->
              {:ok, t} = insert(tree, node, &match_both?/2)
              t

            :p2 ->
              {:ok, t} = insert(tree, node, &match_one?/2)
              t

            :p3 ->
              add_node_p3(tree, node)
          end
        end
      end)

    traverse(tree, [])
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {id, idx}, acc -> acc + id * idx end)
  end
end
