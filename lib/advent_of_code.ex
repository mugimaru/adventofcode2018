defmodule AdventOfCode do
  @moduledoc """
  [Advent Of Code 2018](https://adventofcode.com/2018)
  """

  @spec main(list(String.t())) :: any
  @doc "Escript entry point."
  def main([]), do: main(["help"])
  def main(["help"]), do: IO.puts("Usage: `./aoc 1` where `1` is number of the puzzle.")
  # credo:disable-for-this-file Credo.Check.Warning.IoInspect
  def main([day]), do: solve(day) |> IO.inspect()

  @spec solve(String.t() | integer()) :: term | {:error, String.t()}
  @doc "Solves a puzzle for specified day."
  def solve(day) when is_integer(day), do: solve(to_string(day))

  def solve(day) do
    day_with_pad = String.pad_leading(day, 2, "0")

    with {:ok, module} <- solver_module(day_with_pad) do
      try do
        apply(module, :solve, [input(day_with_pad)])
      rescue
        err ->
          {:error, inspect(err)}
      end
    else
      {:error, :module_not_found} ->
        {:error, "Not implemented"}
    end
  end

  defp solver_module(day) do
    module = String.to_existing_atom("#{__MODULE__}.Day#{day}")
    {:ok, module}
  rescue
    ArgumentError ->
      {:error, :module_not_found}
  end

  defp input(day) do
    day |> input_file_path() |> File.read!()
  end

  defp input_file_path(day) do
    Path.join([File.cwd!(), "inputs", day])
  end
end
