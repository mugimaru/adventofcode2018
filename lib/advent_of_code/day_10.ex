defmodule AdventOfCode.Day10 do
  @moduledoc ~S"""
  [Advent Of Code day 10](https://adventofcode.com/2018/day/10).
  """

  @spec solve(day :: String.t(), input :: Enumerable.t()) :: :ok
  @spec solve(day :: String.t(), input :: Enumerable.t(), io_device :: term) :: :ok

  def solve(day, input), do: solve(day, input, :stdio)

  def solve(_part, input, io_device) do
    points = Enum.into(input, %{}, &parse_line/1)

    1
    |> Stream.iterate(&(&1 + 1))
    |> Enum.take_while(&iterate(points, &1, io_device))

    :ok
  end

  defp iterate(points, step, io_device) do
    points_at_step = points_at(points, step)

    if all_points_connected?(points_at_step) do
      IO.puts(io_device, "At step #{step}:")
      IO.write(io_device, points_at_step |> printable_grid() |> Enum.join("\n"))
      false
    else
      true
    end
  end

  defp points_at(points, step) do
    Enum.into(points, %{}, fn {{x, y}, {vx, vy}} ->
      {{x + vx * step, y + vy * step}, {vx, vy}}
    end)
  end

  defp printable_grid(points_map) do
    {min_x, max_x} = Enum.map(points_map, fn {{x, _}, _} -> x end) |> Enum.min_max()
    {min_y, max_y} = Enum.map(points_map, fn {{_, y}, _} -> y end) |> Enum.min_max()

    for y <- min_y..max_y do
      min_x..max_x
      |> Enum.map(fn x -> if Map.has_key?(points_map, {x, y}), do: "#", else: "." end)
      |> Enum.join()
    end
  end

  defp all_points_connected?(points) do
    Enum.all?(points, fn {point, _v} ->
      points_around(point) |> Enum.any?(&Map.has_key?(points, &1))
    end)
  end

  defp points_around({px, py}) do
    for x <- -1..1, y <- -1..1, x != 0 || y != 0, do: {px + x, py + y}
  end

  defp parse_line(line) do
    [[x], [y], [vx], [vy]] = Regex.scan(~r/[-?\d]+/, line)
    {{String.to_integer(x), String.to_integer(y)}, {String.to_integer(vx), String.to_integer(vy)}}
  end
end
