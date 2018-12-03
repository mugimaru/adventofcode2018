defmodule AdventOfCode.Input do
  @moduledoc """
  AoC input reader.
  """

  @doc "Returns an input for given day."
  @spec get(day :: String.t()) :: term

  def get("03"), do: stream_file_lines!("03")
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
