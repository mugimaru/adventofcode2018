defmodule AdventOfCode.Day17 do
  @moduledoc ~S"""
  [Advent Of Code day 17](https://adventofcode.com/2018/day/17).
  """

  @sand "."
  @clay "#"
  @flow "|"
  @rest "~"

  import AdventOfCode.Utils, only: [map_increment: 2]

  def solve("1", input) do
    with %{"~" => a, "|" => b} <- do_solve(input), do: a + b
  end

  def solve("2", input) do
    with %{"~" => a} <- do_solve(input), do: a
  end

  defp do_solve(input) do
    {start_point, grid} = parse_input(input)
    {min_y, max_y} = Enum.map(grid, fn {{_x, y}, _} -> y end) |> Enum.min_max()

    grid
    |> drop_water(start_point, max_y)
    |> Enum.reduce(%{}, fn {{_x, y}, value}, acc ->
      if y >= min_y && y <= max_y do
        map_increment(acc, value)
      else
        acc
      end
    end)
  end

  defp drop_water(grid, {_x, y}, max_y) when y >= max_y, do: grid

  defp drop_water(grid, {x, y}, max_y) do
    [:down, :left, :right, :fill] |> Enum.reduce(grid, fn dir, acc -> do_drop_water(dir, acc, {x, y}, max_y) end)
  end

  defp do_drop_water(:fill, grid, current, max_y), do: flow(:fill, grid, max_y, {current, nil}, nil)

  defp do_drop_water(dir, grid, {x, y}, max_y) do
    next = next(dir, grid, {x, y})
    bottom_value = Map.get(grid, {x, y + 1}, @sand)

    flow(dir, grid, max_y, next, bottom_value)
  end

  defp next(:down, grid, {x, y}), do: {{x, y + 1}, Map.get(grid, {x, y + 1}, @sand)}
  defp next(:left, grid, {x, y}), do: {{x - 1, y}, Map.get(grid, {x - 1, y}, @sand)}
  defp next(:right, grid, {x, y}), do: {{x + 1, y}, Map.get(grid, {x + 1, y}, @sand)}

  defp flow(:down, grid, max_y, {next, @sand}, _) do
    Map.put(grid, next, @flow) |> drop_water(next, max_y)
  end

  defp flow(:left, grid, max_y, {next, @sand}, bottom) when bottom in [@clay, @rest] do
    Map.put(grid, next, @flow) |> drop_water(next, max_y)
  end

  defp flow(:right, grid, max_y, {next, @sand}, bottom) when bottom in [@clay, @rest] do
    Map.put(grid, next, @flow) |> drop_water(next, max_y)
  end

  defp flow(:fill, grid, _max_y, {current, _}, _) do
    if inside_reservoir?(grid, current), do: rest_line(grid, current), else: grid
  end

  defp flow(_, grid, _, _, _), do: grid

  defp inside_reservoir?(grid, {x, y}) do
    grid[{x, y}] in [@flow, @sand] && do_check_inside_reservoir(grid, x, y, -1) && do_check_inside_reservoir(grid, x, y, +1)
  end

  defp do_check_inside_reservoir(grid, x, y, step) do
    bottom_ok = grid[{x, y + 1}] in [@clay, @rest]
    next = grid[{x + step, y}]

    cond do
      bottom_ok && next == @clay ->
        x + step

      bottom_ok && next == @flow ->
        do_check_inside_reservoir(grid, x + step, y, step)

      true ->
        false
    end
  end

  defp rest_line(grid, {x, y}) do
    from_x = do_check_inside_reservoir(grid, x, y, -1)
    to_x = do_check_inside_reservoir(grid, x, y, +1)

    Enum.reduce((from_x + 1)..(to_x - 1), grid, &Map.put(&2, {&1, y}, @rest))
  end

  defp parse_input(input) do
    input
    |> Enum.reduce(%{}, fn line, map ->
      parse_line(line) |> Enum.reduce(map, fn point, acc -> Map.put(acc, point, @clay) end)
    end)
    |> normalize_grid()
  end

  defp normalize_grid(grid) do
    {{min_x, _}, _} = Enum.min_by(grid, fn {{x, _}, _} -> x end)
    normalized = Enum.into(grid, %{}, fn {{x, y}, value} -> {{x - min_x, y}, value} end) |> Map.put({500 - min_x, 0}, "+")
    {{500 - min_x, 0}, normalized}
  end

  defp parse_line(line) do
    map = %{} = Regex.named_captures(~r/(?<a>x|y)=(?<a_value>\d+), (?<b>x|y)=(?<b_from>\d+)\.\.(?<b_to>\d+)/, line)

    for coord <- String.to_integer(map["b_from"])..String.to_integer(map["b_to"]) do
      a_value = String.to_integer(map["a_value"])

      if map["a"] == "x" do
        {a_value, coord}
      else
        {coord, a_value}
      end
    end
  end

  defp print_grid(grid, max_y) do
    {min_x, max_x} = Enum.map(grid, fn {{x, _y}, _} -> x end) |> Enum.min_max()

    Enum.map(0..max_y, fn y ->
      Enum.map(min_x..max_x, fn x -> Map.get(grid, {x, y}, @sand) end) |> Enum.join()
    end)
    |> Enum.join("\n")
  end
end
