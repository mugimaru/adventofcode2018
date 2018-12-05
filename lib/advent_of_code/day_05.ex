defmodule AdventOfCode.Day05 do
  @moduledoc ~S"""
  [Advent Of Code day 5](https://adventofcode.com/2018/day/5).

      iex> AdventOfCode.Day05.solve("1", "dabAcCaCBAcCcaDA")
      10
      iex> AdventOfCode.Day05.solve("1", "dabAcCaCBAcCcaDA\n")
      10
  """

  @spec solve(part :: String.t(), String.t()) :: integer

  def solve("1", polymer) do
    polymer
    |> String.trim_trailing()
    |> String.to_charlist()
    |> perform_reaction([])
    |> Enum.count()
  end

  def solve("2", polymer) do
    charlist = polymer |> String.trim_trailing() |> String.to_charlist()

    Enum.reduce(?a..?z, nil, fn char, shortest ->
      candidate = Enum.filter(charlist, &(&1 != char && &1 != char - 32))
      result = candidate |> perform_reaction([]) |> Enum.count()

      if is_nil(shortest) || shortest > result, do: result, else: shortest
    end)
  end

  defp perform_reaction([char | rest], []), do: perform_reaction(rest, [char])

  defp perform_reaction([char | rest], [acc_head | acc_rest] = acc) do
    if react?(char, acc_head) do
      perform_reaction(rest, acc_rest)
    else
      perform_reaction(rest, [char | acc])
    end
  end

  defp perform_reaction([], acc), do: acc

  defp react?(a, b) do
    a != b && max(a, b) - 32 == min(a, b)
  end
end
