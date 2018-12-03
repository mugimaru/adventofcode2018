defmodule AdventOfCode.Day03.ElvenPlan do
  @moduledoc false

  defstruct [:id, :top_left, :bottom_right]
  @type t :: %__MODULE__{id: integer, top_left: {integer, integer}, bottom_right: {integer, integer}}

  @spec from_string!(String.t()) :: __MODULE__.t()

  def from_string!(<<_::8, string::binary>>) do
    [id, x, y, width, height] = String.split(string, ~r/\D+/) |> Enum.map(&String.to_integer/1)

    struct(__MODULE__,
      id: id,
      top_left: {x, y},
      bottom_right: {x + width - 1, y + height - 1}
    )
  end

  @spec occupied_points(__MODULE__.t()) :: list({integer, integer})

  def occupied_points(%__MODULE__{top_left: {lx, ly}, bottom_right: {rx, ry}}) do
    for x <- lx..rx, y <- ly..ry, do: {x, y}
  end

  @spec overlap?(__MODULE__.t(), __MODULE__.t()) :: boolean

  def overlap?(%{top_left: {x1, y1}, bottom_right: {rx1, ry1}}, %{top_left: {x2, y2}, bottom_right: {rx2, ry2}}) do
    cond do
      x1 > rx2 || rx1 < x2 ->
        false

      y1 > ry2 || ry1 < y2 ->
        false

      true ->
        true
    end
  end
end
