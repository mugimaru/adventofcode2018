defmodule AdventOfCode.Day19Test do
  use ExUnit.Case, async: true
  import AdventOfCode.Day19

  @input Enum.join(
           [
             "#ip 0",
             "seti 5 0 1",
             "seti 6 0 2",
             "addi 0 1 0",
             "addr 1 2 3",
             "setr 1 0 0",
             "seti 8 0 4",
             "seti 9 0 5"
           ],
           "\n"
         )

  test "solves part 1" do
    assert 6 == solve("1", @input)
  end
end
