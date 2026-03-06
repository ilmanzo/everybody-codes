defmodule Q3Test do
  use ExUnit.Case
  doctest Q3

  test "part1 with samplea.txt" do
    assert Q3.solve("../samplea.txt", :p1) == 43
  end

  test "part2 with sampleb.txt" do
    assert Q3.solve("../sampleb.txt", :p2) == 50
  end

  test "part3 with samplec.txt" do
    assert Q3.solve("../samplec.txt", :p3) == 60
  end
end
