defmodule AdventOfCode.Day14Test do
  use ExUnit.Case, async: true
  import AdventOfCode.Day14

  test "solved part 1" do
    assert "5158916779" == solve("1", 9)
    assert "0124515891" == solve("1", 5)
    assert "9251071085" == solve("1", 18)
    assert "5941429882" == solve("1", 2018)
  end

  test "solves part 2" do
    assert solve("2", 51589) == 9
    # assert solve("2", 01245) == 5
    assert solve("2", 92510) == 18
    assert solve("2", 59414) == 2018
  end
end
