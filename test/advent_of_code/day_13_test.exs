defmodule AdventOfCode.Day13Test do
  use ExUnit.Case, async: true
  import AdventOfCode.Day13

  defp read_input(path) do
    with {:ok, pid} <- File.open(path) do
      content = IO.binread(pid, :all)
      :ok = File.close(pid)
      content
    end
  end

  test "parses input" do
    assert {carts, track} = parse(read_input("test/support/fixtures/day_13"))

    assert [
             {{2, 0}, :right, _},
             {{9, 3}, :down, _}
           ] = Enum.sort(carts)

    assert track == %{
             {0, 0} => :right_turn,
             {0, 4} => :left_turn,
             {2, 2} => :right_turn,
             {2, 4} => :crossing,
             {2, 5} => :left_turn,
             {4, 0} => :left_turn,
             {4, 2} => :crossing,
             {4, 4} => :right_turn,
             {7, 1} => :right_turn,
             {7, 2} => :crossing,
             {7, 4} => :left_turn,
             {9, 2} => :left_turn,
             {9, 4} => :crossing,
             {9, 5} => :right_turn,
             {12, 1} => :left_turn,
             {12, 4} => :right_turn
           }
  end

  test "solves 1st part" do
    assert {7, 3} == solve("1", read_input("test/support/fixtures/day_13"))
  end

  test "solves 2nd part" do
    assert {6, 4} == solve("2", read_input("test/support/fixtures/day_13_p2"))
  end
end
