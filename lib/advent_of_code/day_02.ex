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

    Enum.reduce_while(ids, ids, fn current_id, ids_to_compare ->
      result =
        ids_to_compare
        |> Stream.map(fn id -> {id, diff(id, current_id)} end)
        |> Enum.find(fn {_id, diff} -> Enum.count(diff) == 1 end)

      case result do
        nil ->
          {:cont, ids_to_compare}

        {found_id, [diff_index]} ->
          {:halt, found_id |> String.codepoints() |> List.delete_at(diff_index) |> Enum.join()}
      end
    end)
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
