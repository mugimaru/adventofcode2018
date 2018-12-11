defmodule AdventOfCode.Day11 do
  @moduledoc ~S"""
  [Advent Of Code day 11](https://adventofcode.com/2018/day/11).

      iex> AdventOfCode.Day11.power_level({3, 5}, 8)
      4
      iex> AdventOfCode.Day11.power_level({33, 45}, 18)
      4
      iex> AdventOfCode.Day11.power_level({122, 79}, 57)
      -5
      iex> AdventOfCode.Day11.power_level({217, 196}, 39)
      0
      iex> AdventOfCode.Day11.power_level({101, 153}, 71)
      4

      iex> AdventOfCode.Day11.solve("1", 18)
      {{33, 45}, 29, 3}

      iex> AdventOfCode.Day11.solve("1", 18, 16)
      {{90, 269}, 113, 16}

      iex> AdventOfCode.Day11.solve("1", 42)
      {{21, 61}, 30, 3}
  """

  @grid_size 300

  @spec solve(day :: String.t(), input :: integer) :: integer

  def solve("1", serial_number, square_size) do
    calculate_power_levels(serial_number) |> do_solve(square_size)
  end

  def solve("1", serial_number), do: solve("1", serial_number, 3)

  # TODO: figure out how to make it faster
  def solve("2", serial_number) do
    power_levels = calculate_power_levels(serial_number)

    (1..300)
    |> Stream.map(&do_solve(power_levels, &1))
    |> Enum.max_by(fn {_first_point, power_level, _square_size} -> power_level end)
  end

  defp do_solve(power_levels, square_size) do
    range = 1..@grid_size
    {point, power_level} =
      (for x <- range, y <- range, square_inside_grid?({x, y}, square_size), do: {{x, y}, total_power({x, y}, power_levels, square_size)})
      |> Enum.max_by(fn {_point, power} -> power end)

    {point, power_level, square_size}
  end

  defp calculate_power_levels(serial_number) do
    Enum.into((for x <- (1..@grid_size), y <- (1..@grid_size), do: {x, y}), %{}, fn point -> {point, power_level(point, serial_number)} end)
  end

  defp total_power(points, power_levels) when is_list(points) do
    Enum.reduce(points, 0, fn point, acc -> acc + Map.fetch!(power_levels, point) end)
  end

  defp total_power({_, _} = first_point, power_levels, square_size) do
    square_points(first_point, square_size) |> total_power(power_levels)
  end

  defp square_points({px, py}, square_size) do
    range = (0..square_size - 1)
    for x <- range, y <- range, do: {px + x, py + y}
  end

  defp square_inside_grid?({x, y}, square_size) do
    x + square_size - 1 <= @grid_size && y + square_size - 1 <= @grid_size
  end

  @spec power_level(cell :: {integer, integer}, serial_number :: integer) :: integer
  def power_level({x, y}, serial_number) do
    rack_id = x + 10
    hundreds((rack_id * y + serial_number) * rack_id) - 5
  end

  defp hundreds(int), do: int |> to_string |> String.codepoints() |> Enum.at(-3) |> String.to_integer()
end
