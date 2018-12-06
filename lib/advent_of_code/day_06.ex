defmodule AdventOfCode.Day06 do
  @moduledoc ~S"""
  [Advent Of Code day 6](https://adventofcode.com/2018/day/6).

      iex> input = Enum.join(["1, 1", "1, 6", "8, 3", "3, 4", "5, 5", "8, 9"], "\n")
      iex> AdventOfCode.Day06.solve("1", input)
      17
  """
  import AdventOfCode.Utils, only: [map_increment: 2]

  @spec solve(part :: String.t(), String.t()) :: integer

  def solve("1", input) do
    {{{min_x, min_y}, {max_x, max_y}}, coordinates} = parse_coordinates(input)

    {_point, frequency} =
      for(x <- min_x..max_x, y <- min_y..max_y, do: {x, y})
      |> build_points_frequncy_map(coordinates, {[min_x, max_x], [min_y, max_y]})
      |> Enum.max_by(fn {_point, frequency} -> frequency end)

    frequency
  end

  defp manhattan_distance({x, y}, {x1, y1}) do
    abs(x - x1) + abs(y - y1)
  end

  defp build_points_frequncy_map(all_points, coordinates, {banned_x, banned_y}) do
    initial_acc = Enum.into(coordinates, %{}, &{&1, 0})

    Enum.reduce(all_points, initial_acc, fn {x, y} = point, acc ->
      case closest_point(point, coordinates) do
        :more_than_one ->
          acc

        cp ->
          cond do
            not Map.has_key?(acc, cp) ->
              acc

            x in banned_x || y in banned_y ->
              Map.delete(acc, cp)

            true ->
              map_increment(acc, cp)
          end
      end
    end)
  end

  defp closest_point(point, points) do
    [{x, xd}, {y, yd}] =
      points
      |> Enum.map(&{&1, manhattan_distance(&1, point)})
      |> Enum.sort_by(fn {_, distance} -> distance end)
      |> Enum.take(2)

    cond do
      xd == yd ->
        :more_than_one

      xd > yd ->
        y

      true ->
        x
    end
  end

  defp parse_coordinates(string) do
    string
    |> String.split("\n")
    |> Enum.reduce({{{nil, nil}, {nil, nil}}, []}, fn str, {minmax, acc} ->
      coordinate = do_parse(str)
      updated_minmax = maybe_update_minmax(coordinate, minmax)
      {updated_minmax, [coordinate | acc]}
    end)
  end

  defp do_parse(string) do
    [x, y] = String.split(string, ", ") |> Enum.map(&String.to_integer/1)
    {x, y}
  end

  defp maybe_update_minmax({x, y}, {{min_x, min_y}, {max_x, max_y}}) do
    {{_min(min_x, x), _min(min_y, y)}, {_max(max_x, x), _max(max_y, y)}}
  end

  defp _min(nil, b), do: b
  defp _min(a, nil), do: a
  defp _min(a, b), do: Kernel.min(a, b)

  defp _max(nil, b), do: b
  defp _max(a, nil), do: a
  defp _max(a, b), do: Kernel.max(a, b)
end
