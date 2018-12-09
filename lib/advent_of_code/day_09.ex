defmodule AdventOfCode.Day09 do
  @moduledoc ~S"""
  [Advent Of Code day 9](https://adventofcode.com/2018/day/9).

  Works extremely slow and I have no idea how to make it significantly faster in elixir.

      iex> AdventOfCode.Day09.solve("1", {9, 25})
      32

      iex> AdventOfCode.Day09.solve("1", {10, 1618})
      8317

      iex> AdventOfCode.Day09.solve("1", {13, 7999})
      146373

      iex> AdventOfCode.Day09.solve("1", {17, 1104})
      2764

      iex> AdventOfCode.Day09.solve("1", {21, 6111})
      54718

      iex> AdventOfCode.Day09.solve("1", {30, 5807})
      37305
  """

  import AdventOfCode.Utils, only: [map_increment: 3]
  alias __MODULE__.Circle

  @ruby_solution Path.join([File.cwd!, "lib/advent_of_code/day_09.rb"])
  @solution_method if Mix.env() == :test, do: :do_solve, else: :do_solve_in_ruby

  def solve("1", {number_of_players, marbles}) do
    apply(__MODULE__, @solution_method, [number_of_players, marbles])
  end

  def solve("2", {number_or_players, marbles}), do: solve("1", {number_or_players, marbles * 100})

  def do_solve_in_ruby(a, b) do
    "ruby"
    |> System.cmd([@ruby_solution, to_string(a), to_string(b)])
    |> elem(0)
    |> String.trim_trailing()
    |> String.to_integer()
  end

  def do_solve(number_of_players, marbles) do
    players = Enum.into(1..number_of_players, %{}, &{&1, 0})

    Enum.reduce(1..marbles, {Circle.new([0], []), players}, fn marble, {circle, players} ->
      if rem(marble, 23) == 0 do
        circle = Circle.rotate(circle, 7)
        {value, circle} = Circle.pop(circle)
        players = map_increment(players, rem(marble, number_of_players), value + marble)
        circle = Circle.rotate(circle, -1)

        {circle, players}
      else
        {Circle.rotate(circle, -1) |> Circle.push(marble), players}
      end
    end)
    |> elem(1)
    |> Map.values()
    |> Enum.max()
  end
end
