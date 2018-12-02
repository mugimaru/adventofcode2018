defmodule AdventOfCode.Day01 do
  @moduledoc ~S"""
  [Advent Of Code day 1](https://adventofcode.com/2018/day/1).

      iex> AdventOfCode.Day01.solve("1", Enum.join(~w[+1 -2 +43], "\n"))
      42

      iex> AdventOfCode.Day01.solve("2", Enum.join(~w[+44 -2 +12 -12], "\n"))
      42
  """

  @spec solve(part :: String.t(), input :: String.t()) :: term
  def solve("1", input) do
    input
    |> String.split("\n")
    |> Enum.reduce(0, &(&2 + String.to_integer(&1)))
  end

  def solve("2", input) do
    changes = input |> String.split("\n") |> Enum.map(&String.to_integer/1)
    do_solve_part_2(0, %{}, changes)
  end

  defp do_solve_part_2(initial, prev_values_map, changes) do
    case process_changes(initial, prev_values_map, changes) do
      {:solved, result} ->
        result

      {new_frequency, new_prev_values_map} ->
        do_solve_part_2(new_frequency, new_prev_values_map, changes)
    end
  end

  defp process_changes(initial_freq, values_map, changes) do
    Enum.reduce_while(changes, {initial_freq, values_map}, fn change, {current_freq, values_map} ->
      updated_freq = current_freq + change

      case Map.get_and_update(values_map, updated_freq, &{&1, if(is_nil(&1), do: 1, else: &1 + 1)}) do
        {nil, map} ->
          {:cont, {updated_freq, map}}

        {1, _map} ->
          {:halt, {:solved, updated_freq}}
      end
    end)
  end
end
