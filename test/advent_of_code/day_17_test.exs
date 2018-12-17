defmodule AdventOfCode.Day17Test do
  use ExUnit.Case, async: true
  import AdventOfCode.Day17

  @input [
    "x=495, y=2..7",
    "y=7, x=495..501",
    "x=501, y=3..7",
    "x=498, y=2..4",
    "x=506, y=1..2",
    "x=498, y=10..13",
    "x=504, y=10..13",
    "y=13, x=498..504"
  ]

  test "solves part 1" do
    assert 57 == solve("1", @input)
  end

  test "solves part 2" do
    assert 29 == solve("2", @input)
  end
end
