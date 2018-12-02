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
    |> Enum.reduce(0, fn v, acc -> acc + String.to_integer(v) end)
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

  defp process_changes(initial_freq, prev_values_map, changes) do
    Enum.reduce_while(changes, {initial_freq, prev_values_map}, fn change, {current_freq, prev_values_map} ->
      change_frequency(prev_values_map, current_freq + change)
    end)
  end

  defp change_frequency(prev_values_map, new_freq) do
    update_result =
      Map.get_and_update(prev_values_map, new_freq, fn
        nil ->
          {nil, 1}

        current ->
          {current, current + 1}
      end)

    case update_result do
      {nil, updated_prev_values_map} ->
        {:cont, {new_freq, updated_prev_values_map}}

      {1, _} ->
        {:halt, {:solved, new_freq}}
    end
  end
end
