defmodule AdventOfCode.Day14Test do
  use ExUnit.Case, async: true
  import AdventOfCode.Day14

  test "solved part 1" do
    assert "5158916779" == solve("1", 9)
    assert "0124515891" == solve("1", 5)
    assert "9251071085" == solve("1", 18)
    assert "5941429882" == solve("1", 2018)
  end
end
