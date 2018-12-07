defmodule AdventOfCode.Input do
  @moduledoc """
  AoC input reader.
  """
  @stream_lines_for ["03", "04", "07"]

  @doc "Returns an input for given day."
  @spec get(day :: String.t()) :: term

  def get(day) when day in @stream_lines_for, do: stream_file_lines!(day)
  def get(day), do: read_file!(day)

  defp read_file!(day) do
    day |> input_file_path() |> File.read!()
  end

  defp stream_file_lines!(day) do
    day |> input_file_path() |> File.stream!([], :line) |> Stream.map(&String.trim_trailing/1)
  end

  defp input_file_path(day) do
    Path.join([File.cwd!(), "inputs", day])
  end
end
