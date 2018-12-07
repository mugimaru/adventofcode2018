defmodule AdventOfCode.Day07 do
  @moduledoc ~S"""
  [Advent Of Code day 7](https://adventofcode.com/2018/day/7).

    iex> input = [
    ...>  "Step C must be finished before step A can begin.",
    ...>  "Step C must be finished before step F can begin.",
    ...>  "Step A must be finished before step B can begin.",
    ...>  "Step A must be finished before step D can begin.",
    ...>  "Step B must be finished before step E can begin.",
    ...>  "Step D must be finished before step E can begin.",
    ...>  "Step F must be finished before step E can begin."]
    iex> AdventOfCode.Day07.solve("1", input)
    "CABDFE"
    iex>AdventOfCode.Day07.solve("2", input)
    nil
  """

  def solve("1", input) do
    requirements = input_into_requirements_map(input)

    {reversed_sequence, _} =
      Enum.reduce(1..Enum.count(requirements), {[], requirements}, fn _, {acc, requirements} ->
        {next_step, _} = Enum.min_by(requirements, fn {step, preq_list} -> {Enum.count(preq_list), step} end)
        {[next_step | acc], delete_step_from_requirements(requirements, next_step)}
      end)

    reversed_sequence |> Enum.reverse() |> Enum.join()
  end

  def solve("2", _input) do
    nil
  end

  defp delete_step_from_requirements(requirements, step_to_delete) do
    requirements
    |> Map.delete(step_to_delete)
    |> Enum.into(%{}, fn {step, preq_list} -> {step, List.delete(preq_list, step_to_delete)} end)
  end

  defp input_into_requirements_map(input) when is_binary(input) do
    input |> String.split("\n") |> input_into_requirements_map()
  end

  defp input_into_requirements_map(input) do
    Enum.reduce(input, %{}, fn line, acc ->
      <<"Step ", a::binary-size(1), " must be finished before step ", b::binary-size(1), " can begin.">> = line

      acc
      |> Map.update(b, [a], &[a | &1])
      |> Map.put_new(a, [])
    end)
  end
end
