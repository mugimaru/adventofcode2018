defmodule AdventOfCode.Day18Test do
  use ExUnit.Case, async: true
  import AdventOfCode.Day18

  @input Enum.join(
           [
             ".#.#...|#.",
             ".....#|##|",
             ".|..|...#.",
             "..|#.....#",
             "#.#|||#|#|",
             "...#.||...",
             ".|....|...",
             "||...#|.#|",
             "|.||||..|.",
             "...#.|..|."
           ],
           "\n"
         )

  @step_1 Enum.join(
            [
              ".......##.",
              "......|###",
              ".|..|...#.",
              "..|#||...#",
              "..##||.|#|",
              "...#||||..",
              "||...|||..",
              "|||||.||.|",
              "||||||||||",
              "....||..|."
            ],
            "\n"
          )

  @step_2 Enum.join(
            [
              ".......#..",
              "......|#..",
              ".|.|||....",
              "..##|||..#",
              "..###|||#|",
              "...#|||||.",
              "|||||||||.",
              "||||||||||",
              "||||||||||",
              ".|||||||||"
            ],
            "\n"
          )

  test "solves part 1" do
    assert parse_input(@step_1) |> print() == parse_input(@input) |> iterate() |> print()
    assert parse_input(@step_2) |> print() == parse_input(@input) |> iterate() |> iterate() |> print()
    assert 1147 = solve("1", @input)
  end
end
