defmodule AdventOfCode do
  @moduledoc """
  [Advent Of Code 2018](https://adventofcode.com/2018)
  """

  @spec main(list(String.t())) :: any
  @doc "Escript entry point."
  def main([]), do: main(["help"])

  def main(["help"]), do: IO.puts("Usage: `./aoc 1 2` to solve part `2` from pullze `1`.")

  def main([day, part]) do
    started_at = :erlang.system_time(:millisecond)
    result = solve(day, part)
    time_spent_ms = :erlang.system_time(:millisecond) - started_at
    IO.puts("Puzzle #{day}.#{part} solved in #{time_spent_ms}ms, result: \n#{inspect(result)}")
  end

  def main(_), do: main(["help"])

  @spec solve(day :: String.t() | integer(), part :: String.t()) :: term | {:error, String.t()}
  @doc "Solves a puzzle for specified day."
  def solve(day, part) when is_integer(day), do: solve(to_string(day), part)

  def solve(day, part) do
    day_with_pad = String.pad_leading(day, 2, "0")

    with {:ok, module} <- solver_module(day_with_pad) do
      try do
        apply(module, :solve, [part, AdventOfCode.Input.get(day_with_pad)])
      rescue
        err ->
          IO.inspect(err)
          IO.puts(Exception.format_stacktrace(__STACKTRACE__))
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
end
