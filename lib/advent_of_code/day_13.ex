defmodule AdventOfCode.Day13 do
  @moduledoc ~S"""
  [Advent Of Code day 13](https://adventofcode.com/2018/day/13).
  """

  @type point :: {non_neg_integer, non_neg_integer}
  @type direction :: :up | :down | :left | :right
  @type cart :: {position :: point(), direction :: direction(), turns_sequence :: Stream.t()}

  @type track_point_type :: {:left_turn, :rirght_turn, :crossing}
  @type track_point :: {point(), track_point_type()}

  def solve("1", input) do
    parse(input) |> find_first_crash_position()
  end

  def solve("2", input) do
    parse(input) |> find_last_cart_intact()
  end

  defp find_last_cart_intact({carts, track}), do: find_last_cart_intact({carts_in_movement_order(carts), track}, [])

  defp find_last_cart_intact({[last_cart], track}, []) do
    {point, _, _} = move_cart(last_cart, track)
    point
  end

  defp find_last_cart_intact({[], track}, moved_carts) do
    find_last_cart_intact({moved_carts, track})
  end

  defp find_last_cart_intact({[cart | rest_carts], track}, moved_carts) do
    moved_current_cart = move_cart(cart, track)

    case find_crash([moved_current_cart | rest_carts] ++ moved_carts) do
      nil ->
        find_last_cart_intact({rest_carts, track}, [moved_current_cart | moved_carts])

      {_point, crashed_carts} ->
        find_last_cart_intact({remove_crashed(rest_carts, crashed_carts), track}, remove_crashed(moved_carts, crashed_carts))
    end
  end

  def remove_crashed(carts, crashed_carts) do
    Enum.filter(carts, fn c -> c not in crashed_carts end)
  end

  defp find_first_crash_position({carts, track}), do: find_first_crash_position({carts_in_movement_order(carts), track}, [])

  defp find_first_crash_position({[], track}, moved_carts) do
    find_first_crash_position({moved_carts, track})
  end

  defp find_first_crash_position({[cart | rest_carts], track}, moved_carts) do
    moved_current_cart = move_cart(cart, track)

    case find_crash([moved_current_cart | rest_carts] ++ moved_carts) do
      nil ->
        find_first_crash_position({rest_carts, track}, [moved_current_cart | moved_carts])

      {point, _carts} ->
        point
    end
  end

  def parse(input) do
    {carts, track} =
      String.split(input, "\n")
      |> Enum.with_index()
      |> Enum.reduce({[], %{}}, fn {row, y}, acc ->
        row
        |> String.trim_trailing()
        |> String.codepoints()
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {value, x}, acc ->
          do_parse_cell({x, y}, value, acc)
        end)
      end)

    {carts, Enum.into(%{}, track)}
  end

  defp do_parse_cell(point, value, {carts, grid}) do
    case value do
      "v" ->
        {[{point, :down, new_turns_sequence()} | carts], grid}

      "^" ->
        {[{point, :up, new_turns_sequence()} | carts], grid}

      ">" ->
        {[{point, :right, new_turns_sequence()} | carts], grid}

      "<" ->
        {[{point, :left, new_turns_sequence()} | carts], grid}

      "-" ->
        {carts, grid}

      "|" ->
        {carts, grid}

      " " ->
        {carts, grid}

      "+" ->
        {carts, Map.put(grid, point, :crossing)}

      "/" ->
        {carts, Map.put(grid, point, :right_turn)}

      "\\" ->
        {carts, Map.put(grid, point, :left_turn)}
    end
  end

  defp new_turns_sequence, do: [:left, :straight, :right]

  defp find_crash(carts) do
    Enum.group_by(carts, fn {point, _, _} -> point end) |> Enum.find(fn {_point, carts} -> Enum.count(carts) > 1 end)
  end

  defp carts_in_movement_order(carts) do
    Enum.sort_by(carts, fn {{x, y}, _, _} -> {y, x} end)
  end

  defp move_cart({{x, y}, direction, turns_seq}, track) do
    next_point = next_point({x, y}, direction)

    case Map.get(track, next_point) do
      nil ->
        {next_point, direction, turns_seq}

      :crossing ->
        {turn_direction, turns_seq} = cycle_turn_seq(turns_seq)
        {next_point, turn_cart(direction, turn_direction), turns_seq}

      turn_direction ->
        {next_point, turn_cart(direction, turn_direction(direction, turn_direction)), turns_seq}
    end
  end

  defp turn_direction(:up, :left_turn), do: :left
  defp turn_direction(:down, :left_turn), do: :left
  defp turn_direction(_, :left_turn), do: :right

  defp turn_direction(:up, :right_turn), do: :right
  defp turn_direction(:down, :right_turn), do: :right
  defp turn_direction(_, :right_turn), do: :left

  defp next_point({x, y}, direction) do
    case direction do
      :up ->
        {x, y - 1}

      :down ->
        {x, y + 1}

      :left ->
        {x - 1, y}

      :right ->
        {x + 1, y}
    end
  end

  defp turn_cart(cart_direction, turn_direction) do
    case {cart_direction, turn_direction} do
      {:left, :left} -> :down
      {:left, :right} -> :up
      {:right, :left} -> :up
      {:right, :right} -> :down
      {:down, :left} -> :right
      {:down, :right} -> :left
      {any, :straight} -> any
      {:up, any} -> any
    end
  end

  defp cycle_turn_seq([turn | rest_seq]) do
    {turn, rest_seq ++ [turn]}
  end
end
