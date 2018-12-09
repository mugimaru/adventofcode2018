defmodule AdventOfCode.Day09 do
  @moduledoc ~S"""
  [Advent Of Code day 9](https://adventofcode.com/2018/day/9).

  Works extremely slow and I have no idea how to make it significantly faster in elixir.

      iex> AdventOfCode.Day09.solve("1", {9, 25})
      32

      iex> AdventOfCode.Day09.solve("1", {10, 1618})
      8317

      iex> AdventOfCode.Day09.solve("1", {13, 7999})
      146373

      iex> AdventOfCode.Day09.solve("1", {17, 1104})
      2764

      iex> AdventOfCode.Day09.solve("1", {21, 6111})
      54718

      iex> AdventOfCode.Day09.solve("1", {30, 5807})
      37305
  """

  import AdventOfCode.Utils, only: [map_increment: 3]

  defmodule Circle do
    defstruct left: [], right: []

    def new(l, r), do: struct(__MODULE__, left: l, right: r)

    def rotate_counter_clockwise(%{left: []} = circle) do
      rotate_counter_clockwise(%{circle | right: [], left: circle.right})
    end

    def rotate_counter_clockwise(circle) do
      with {value, list} <- List.pop_at(circle.left, -1) do
        %{circle | right: [value | circle.right], left: list}
      end
    end

    def rotate_clockwise(%{right: []} = circle) do
      rotate_clockwise(%{circle | left: [], right: circle.left})
    end

    def rotate_clockwise(%{right: [value | list]} = circle) do
      %{circle | left: List.insert_at(circle.left, -1, value), right: list}
    end

    def rotate(circle, n) when n < 0, do: do_rotate(abs(n), circle, :rotate_clockwise)
    def rotate(circle, 0), do: circle
    def rotate(circle, n), do: do_rotate(n, circle, :rotate_counter_clockwise)

    def push(circle, value) do
      %{circle | left: List.insert_at(circle.left, -1, value)}
    end

    def pop(%{left: []} = circle) do
      with {value, rest} <- List.pop_at(circle.right, -1) do
        {value, %{circle | right: rest}}
      end
    end

    def pop(circle) do
      with {value, rest} <- List.pop_at(circle.left, -1) do
        {value, %{circle | left: rest}}
      end
    end

    defp do_rotate(times, circle, fun_name) do
      Enum.reduce(1..times, circle, fn _, c ->
        apply(__MODULE__, fun_name, [c])
      end)
    end

    defimpl Inspect, for: __MODULE__ do
      def inspect(%{left: left, right: right}, _opts) do
        Enum.join(mark_current(left) ++ right, " ")
      end

      defp mark_current([last]), do: ["(#{last})"]
      defp mark_current([h | t]), do: [h | mark_current(t)]
    end
  end

  def solve("1", {number_of_players, marbles}) do
    players = Enum.into(1..number_of_players, %{}, &{&1, 0})

    Enum.reduce(1..marbles, {Circle.new([0], []), players}, fn marble, {circle, players} ->
      if rem(marble, 23) == 0 do
        circle = Circle.rotate(circle, 7)
        {value, circle} = Circle.pop(circle)
        players = map_increment(players, rem(marble, number_of_players), value + marble)
        circle = Circle.rotate(circle, -1)

        {circle, players}
      else
        {Circle.rotate(circle, -1) |> Circle.push(marble), players}
      end
    end)
    |> elem(1)
    |> Map.values()
    |> Enum.max()
  end

  def solve("2", {number_or_players, marbles}), do: solve("1", {number_or_players, marbles * 100})
end
