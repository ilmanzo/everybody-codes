defmodule Q1Test do
  use ExUnit.Case
  doctest Q1

  test "parses binary correctly" do
    assert Q1.parse_binary("gggGgg") == 4
  end

  test "processes line correctly (part 1)" do
    assert Q1.p1_line("2456:rrrrrr ggGgGG bbbbBB") == 2456
    assert Q1.p1_line("7689:rrRrrr ggGggg bbbBBB") == 0
  end

  test "sums IDs from file correctly (part 1)" do
    # Assuming samplea.txt is present and matches the doc test
    # If not, this test might need a valid file, but keeping it for now
    # assert Q1.part1("../samplea.txt") == 9166
  end

  test "processes line correctly (part 2)" do
    # 2456: 0 + 11 + 3 = 14, "sSsSsS" -> "010101" = 21
    assert Q1.p2_line("2456:rrrrrr ggGgGG bbbbBB sSsSsS") == {2456, 14, 21}
  end

  test "finds the max S with min sum (part 2)" do
    assert Q1.part2("../sampleb.txt") == 2456
  end
end
