defmodule AdventOfCode.Day02 do
  @moduledoc ~S"""
  [Advent Of Code day 2](https://adventofcode.com/2018/day/2).

  iex> AdventOfCode.Day02.solve("1", Enum.join(~w[abcdef bababc abbcde abcccd aabcdd abcdee ababab], "\n"))
  12
  """

  import AdventOfCode.Utils, only: [map_increment: 2]

  @spec solve(part :: String.t(), input :: String.t()) :: term
  def solve("1", input) do
    input
    |> String.split("\n")
    |> Enum.map(&count_letters/1)
    |> Enum.reduce(%{2 => 0, 3 => 0}, fn (id_stats, acc) ->
      Enum.map(acc, fn {k, v} ->
        if Map.has_key?(id_stats, k), do: {k, v + 1}, else: {k, v}
      end)
    end)
    |> checksum()
  end

  defp count_letters(string) do
    string
    |> String.codepoints()
    |> Enum.reduce(%{}, fn (letter, map) -> map_increment(map, letter) end)
    |> Enum.reduce(%{}, fn ({_letter, count}, map) -> map_increment(map, count) end)
  end

  defp checksum(input), do: Enum.reduce(input, 1, fn ({_, v}, acc) -> acc * v end)
end
