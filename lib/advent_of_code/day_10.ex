defmodule AdventOfCode.Day10 do
  @moduledoc ~S"""
  [Advent Of Code day 10](https://adventofcode.com/2018/day/10).
  """

  @spec solve(day :: String.t(), input :: Enumerable.t()) :: :ok

  def solve(day, input), do: solve(day, input, :stdio)

  def solve("1", input, io_device) do
    points = Enum.map(input, &parse_line/1)

    Stream.iterate(0, &(&1 + 1))
    |> Enum.take_while(fn step ->
      points_at_step = iterate(points, step)

      if all_points_connected?(points_at_step) do
        IO.puts(io_device, "At step #{step}:")
        print(points_at_step, io_device)
        false
      else
        true
      end
    end)

    :ok
  end

  def solve("2", input, io_device), do: solve("1", input, io_device)

  def iterate([], _), do: []

  def iterate([head | rest], times) do
    {{x, y}, {vx, vy}} = head
    new_head = {{x + vx * times, y + vy * times}, {vx, vy}}
    [new_head | iterate(rest, times)]
  end

  defp print(points, io_device) do
    points_map = Enum.into(points, %{}, &{elem(&1, 0), 1})
    {min_x, max_x} = Enum.map(points, fn {{x, _}, _} -> x end) |> Enum.min_max()
    {min_y, max_y} = Enum.map(points, fn {{_, y}, _} -> y end) |> Enum.min_max()

    for y <- min_y..max_y do
      row =
        min_x..max_x
        |> Enum.map(fn x -> if Map.has_key?(points_map, {x, y}), do: "#", else: "." end)
        |> Enum.join()

      IO.puts(io_device, row)
    end
  end

  defp all_points_connected?(points) do
    points_map = Enum.into(points, %{}, &{elem(&1, 0), 1})

    Enum.all?(points, fn {point, _v} ->
      Enum.any?(connected_points(point), &Map.has_key?(points_map, &1))
    end)
  end

  defp connected_points({px, py}) do
    for x <- -1..1, y <- -1..1, x != 0 || y != 0, do: {px + x, py + y}
  end

  defp parse_line(line) do
    [[x], [y], [vx], [vy]] = Regex.scan(~r/[-?\d]+/, line)
    {{String.to_integer(x), String.to_integer(y)}, {String.to_integer(vx), String.to_integer(vy)}}
  end
end
