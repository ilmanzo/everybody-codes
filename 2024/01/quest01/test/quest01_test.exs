defmodule Quest01Test do
  use ExUnit.Case

  test "part1" do
    assert Quest01.part1("ABBAC") == 5
  end

  test "part2" do
    assert Quest01.part2("AxBCDDCAxD") == 28
  end
end
