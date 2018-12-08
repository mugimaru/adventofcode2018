defmodule AdventOfCode.Day08 do
  @moduledoc ~S"""
  [Advent Of Code day 8](https://adventofcode.com/2018/day/8).

      iex> AdventOfCode.Day08.solve("1", "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2")
      138

      iex> AdventOfCode.Day08.solve("2", "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2")
      66
  """
  import AdventOfCode.Utils, only: [sum_by: 2]

  def solve("1", input) do
    input
    |> parse_input()
    |> read_node()
    |> elem(0)
    |> sum_meta()
  end

  def solve("2", input) do
    input
    |> parse_input()
    |> read_node()
    |> elem(0)
    |> node_value()
  end

  defp node_value([children, meta]) do
    if children == [] do
      Enum.sum(meta)
    else
      meta
      |> Enum.filter(fn m -> m > 0 && m <= Enum.count(children) end)
      |> sum_by(fn i -> Enum.reverse(children) |> Enum.at(i - 1) |> node_value() end)
    end
  end

  defp sum_meta([]), do: 0

  defp sum_meta([children, meta]) do
    Enum.sum(meta) + sum_by(children, &sum_meta/1)
  end

  defp parse_input(input) do
    input
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end

  defp read_node([c | [m | rest]]) do
    {children, rest} = read_nodes(c, rest)
    {meta, rest} = read_meta(rest, m, [])

    {[children, meta], rest}
  end

  defp read_nodes(0, list), do: {[], list}

  defp read_nodes(n, list) do
    Enum.reduce(1..n, {[], list}, fn _, {nodes_acc, list} ->
      {node, rest} = read_node(list)
      {[node | nodes_acc], rest}
    end)
  end

  defp read_meta(list, 0, acc), do: {acc, list}
  defp read_meta([head | rest], n, acc), do: read_meta(rest, n - 1, [head | acc])
end
