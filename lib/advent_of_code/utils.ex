defmodule AdventOfCode.Utils do
  @moduledoc """
  Common helpers for puzzle solvers.
  """

  @spec map_increment(map, term) :: map
  @spec map_increment(map, term, increment_by :: integer) :: map
  @doc """
  Increments value of a given key.

      iex> %{foo: 41} |> map_increment(:foo) |> map_increment(:bar, 2)
      %{foo: 42, bar: 2}
  """
  def map_increment(map, key, by \\ 1) do
    {_initial_value, updated_map} =
      Map.get_and_update(map, key, fn
        nil ->
          {nil, by}

        current ->
          {current, current + by}
      end)

    updated_map
  end
end
