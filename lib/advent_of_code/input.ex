defmodule AdventOfCode.Input do
  @moduledoc """
  AoC input reader.
  """
  @stream_lines_for ["03", "04", "07", "10"]

  @doc "Returns an input for given day."
  @spec get(day :: String.t()) :: term

  def get("16") do
    {read_file!("16_1"), read_file!("16_2")}
  end

  def get("14"), do: 637_061
  def get("13"), do: read_raw_file("13")
  def get("11"), do: 5235
  def get("09"), do: {410, 72059}

  def get(day) when day in @stream_lines_for, do: stream_file_lines!(day)
  def get(day), do: read_file!(day)

  defp read_file!(day) do
    day |> input_file_path() |> File.read!()
  end

  defp stream_file_lines!(day) do
    day |> input_file_path() |> File.stream!([], :line) |> Stream.map(&String.trim_trailing/1)
  end

  defp read_raw_file(day) do
    {:ok, pid} = day |> input_file_path() |> File.open()
    content = IO.binread(pid, :all)
    :ok = File.close(pid)
    content
  end

  defp input_file_path(day) do
    Path.join([File.cwd!(), "inputs", day])
  end
end
