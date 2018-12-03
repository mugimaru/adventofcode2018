defmodule AdventOfCode.Day03 do
  @moduledoc ~S"""
  [Advent Of Code day 3](https://adventofcode.com/2018/day/3).

  ## ElvenPlan

      iex> ep = AdventOfCode.Day03.ElvenPlan.from_string!("#123 @ 3,2: 5x4")
      iex> op = AdventOfCode.Day03.ElvenPlan.occupied_points(ep)
      iex> Enum.count(op)
      20
      iex> hd(op)
      {3, 2}
      iex> List.last(op)
      {7, 5}

  ## Part 1

      iex> input = %Stream{enum: ["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"], funs: []}
      iex> AdventOfCode.Day03.solve("1", input)
      4
  """

  import AdventOfCode.Utils, only: [map_increment: 2]

  defmodule ElvenPlan do
    @moduledoc false

    defstruct [:id, :x, :y, :width, :height]
    @type t :: %__MODULE__{id: integer, x: integer, y: integer, width: integer, height: integer}

    @spec from_string!(String.t()) :: __MODULE__.t()

    def from_string!(<<_::8, string::binary>>) do
      [id, x, y, width, height] = String.split(string, ~r/\D+/) |> Enum.map(&String.to_integer/1)
      struct(__MODULE__, id: id, x: x, y: y, width: width, height: height)
    end

    @spec occupied_points(__MODULE__.t()) :: list({integer, integer})

    def occupied_points(%__MODULE__{x: px, y: py, width: width, height: height}) do
      for x <- 0..(width - 1), y <- 0..(height - 1), do: {x + px, y + py}
    end
  end

  @spec solve(part :: String.t(), file_stream :: Stream.t()) :: integer
  def solve("1", file_stream) do
    file_stream
    |> Stream.map(&ElvenPlan.from_string!/1)
    |> Stream.map(&ElvenPlan.occupied_points/1)
    |> Enum.reduce(%{}, fn points, map ->
      Enum.reduce(points, map, fn point, map -> map_increment(map, point) end)
    end)
    |> Enum.filter(fn {_k, v} -> v > 1 end)
    |> Enum.count()
  end
end
