defmodule AdventOfCode.Day18 do
  @moduledoc ~S"""
  [Advent Of Code day 18](https://adventofcode.com/2018/day/18).
  """

  import AdventOfCode.Utils, only: [map_increment: 2]

  @open "."
  @tree "|"
  @lumberyard "#"

  def solve("1", input) do
    grid = input |> parse_input()
    Enum.reduce(1..10, grid, fn _, grid -> iterate(grid) end) |> resources_value()
  end

  def solve("2", input) do
    grid = input |> parse_input()

    Enum.reduce_while(1..1_000_000_000, grid, fn _n, grid ->
      # grid starts to cycle at some point. We need to figure out the pattern and apply it to the rest of iterations
      new_grid = iterate(grid)
      new_grid |> print() |> IO.puts()
      {:cont, new_grid}
    end)
  end

  def iterate(grid) do
    Enum.reduce(grid, %{}, fn {point, value}, acc ->
      Map.put(acc, point, next_value(value, adj_stats(grid, point)))
    end)
  end

  defp resources_value(grid) do
    stats = Enum.reduce(grid, %{}, fn {_point, value}, acc -> map_increment(acc, value) end)
    stats[@tree] * stats[@lumberyard]
  end

  defp adj_stats(grid, point), do: points_stats(grid, adjacent(point))

  defp adjacent({px, py}) do
    for x <- -1..1, y <- -1..1, x + px >= 0 && y + py >= 0 && (x != 0 || y != 0), do: {px + x, py + y}
  end

  defp points_stats(grid, points), do: Enum.reduce(points, %{}, &map_increment(&2, Map.get(grid, &1)))

  defp next_value(@open, %{@tree => c}) when c >= 3, do: @tree
  defp next_value(@tree, %{@lumberyard => c}) when c >= 3, do: @lumberyard
  defp next_value(@lumberyard, %{@lumberyard => l, @tree => t}) when t >= 1 and l >= 1, do: @lumberyard
  defp next_value(@lumberyard, _), do: @open
  defp next_value(value, _), do: value

  def parse_input(input) do
    String.split(input, "\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      String.codepoints(line)
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {point, x}, acc ->
        Map.put(acc, {x, y}, point)
      end)
    end)
  end

  def print(grid) do
    max = :math.sqrt(Enum.count(grid)) |> Kernel.trunc()

    Enum.map(0..(max - 1), fn y ->
      Enum.map(0..(max - 1), fn x -> Map.get(grid, {x, y}) end) |> Enum.join()
    end)
    |> Enum.join("\n")
  end
end
