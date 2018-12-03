defmodule AdventOfCode.Day03 do
  @moduledoc ~S"""
  [Advent Of Code day 3](https://adventofcode.com/2018/day/3).

  ## ElvenPlan

      iex> ep = AdventOfCode.Day03.ElvenPlan.from_string!("#123 @ 3,2: 5x4")
      iex> op = AdventOfCode.Day03.ElvenPlan.occupied_points(ep)
      iex> Enum.count(op)
      20
      iex> hd(op)
      {3, 2}
      iex> List.last(op)
      {7, 5}

      iex> import AdventOfCode.Day03.ElvenPlan
      iex> overlap?(from_string!("#1 @ 1,3: 4x4"), from_string!("#2 @ 3,1: 4x4"))
      true
      iex> overlap?(from_string!("#1 @ 1,3: 4x4"), from_string!("#3 @ 5,5: 2x2"))
      false
      iex> overlap?(from_string!("#2 @ 3,1: 4x4"), from_string!("#3 @ 5,5: 2x2"))
      false

  ## Part 1

      iex> input = %Stream{enum: ["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"], funs: []}
      iex> AdventOfCode.Day03.solve("1", input)
      4

  ## Part 2

      iex> input = %Stream{enum: ["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"], funs: []}
      iex> AdventOfCode.Day03.solve("2", input)
      [3]
  """

  import AdventOfCode.Utils, only: [map_increment: 2]
  alias AdventOfCode.Day03.ElvenPlan

  @spec solve(part :: String.t(), file_stream :: Stream.t()) :: integer
  def solve("1", file_stream) do
    file_stream
    |> Stream.map(&ElvenPlan.from_string!/1)
    |> Stream.map(&ElvenPlan.occupied_points/1)
    |> Enum.reduce(%{}, fn points, map ->
      Enum.reduce(points, map, fn point, map -> map_increment(map, point) end)
    end)
    |> Enum.filter(fn {_k, v} -> v > 1 end)
    |> Enum.count()
  end

  def solve("2", file_stream) do
    plans = Enum.map(file_stream, &ElvenPlan.from_string!/1)
    plan = find_non_overlapping(plans, plans)

    [plan.id]
  end

  defp find_non_overlapping([current | rest], plans) do
    if Enum.all?(plans, fn plan -> plan.id == current.id || not ElvenPlan.overlap?(current, plan) end) do
      current
    else
      find_non_overlapping(rest, plans)
    end
  end
end
