defmodule AdventOfCode.Day02 do
  @moduledoc ~S"""
  [Advent Of Code day 2](https://adventofcode.com/2018/day/2).

  iex> AdventOfCode.Day02.solve("1", Enum.join(~w[abcdef bababc abbcde abcccd aabcdd abcdee ababab], "\n"))
  12

  iex> AdventOfCode.Day02.solve("2", Enum.join(~w[abcde fghij klmno pqrst fguij axcye wvxyz], "\n"))
  "fgij"
  """

  import AdventOfCode.Utils, only: [map_increment: 2]

  @spec solve(part :: String.t(), input :: String.t()) :: term
  def solve("1", input) do
    input
    |> String.split("\n")
    |> Enum.map(&count_letters/1)
    |> Enum.reduce(%{2 => 0, 3 => 0}, fn id_stats, acc ->
      Enum.map(acc, fn {k, v} ->
        if Map.has_key?(id_stats, k), do: {k, v + 1}, else: {k, v}
      end)
    end)
    |> checksum()
  end

  def solve("2", input) do
    ids = input |> String.split("\n")

    {{box_id, _second_box_id}, [diff_index]} =
      Stream.flat_map(ids, fn a ->
        Stream.flat_map(ids, fn b -> [{a, b}] end)
      end)
      |> Stream.filter(fn {a, b} -> a != b end)
      |> Stream.uniq_by(fn {a, b} -> {min(a, b), max(a, b)} end)
      |> Stream.map(fn {a, b} -> {{a, b}, diff(a, b)} end)
      |> Enum.find(fn {_, diff} -> Enum.count(diff) == 1 end)

    box_id |> String.codepoints() |> List.delete_at(diff_index) |> Enum.join()
  end

  defp count_letters(string) do
    string
    |> String.codepoints()
    |> Enum.reduce(%{}, fn letter, map -> map_increment(map, letter) end)
    |> Enum.reduce(%{}, fn {_letter, count}, map -> map_increment(map, count) end)
  end

  defp checksum(input), do: Enum.reduce(input, 1, fn {_, v}, acc -> acc * v end)

  defp diff(a, b) do
    a_letters = String.codepoints(a)
    b_letters = String.codepoints(b)

    Enum.reduce(0..(Enum.count(a_letters) - 1), [], fn i, diff ->
      if Enum.at(a_letters, i) != Enum.at(b_letters, i) do
        [i | diff]
      else
        diff
      end
    end)
  end
end
