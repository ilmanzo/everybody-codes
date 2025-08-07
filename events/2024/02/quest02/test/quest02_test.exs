defmodule Quest02Test do
  use ExUnit.Case

  @p1_example """
  WORDS:THE,OWE,MES,ROD,HER

  AWAKEN THE POWER ADORNED WITH THE FLAMES BRIGHT IRE
  """

  test "part1" do
    assert Quest02.part1(@p1_example) == 5
  end

end
