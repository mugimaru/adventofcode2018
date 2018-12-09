defmodule AdventOfCode.Day09.Circle do
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
