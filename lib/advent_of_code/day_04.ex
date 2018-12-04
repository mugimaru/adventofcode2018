defmodule AdventOfCode.Day04 do
  @moduledoc ~S"""
  [Advent Of Code day 4](https://adventofcode.com/2018/day/4).

      iex> inp = ["[1518-11-01 00:00] Guard #10 begins shift",
      ...>         "[1518-11-01 00:05] falls asleep",
      ...>         "[1518-11-01 00:25] wakes up",
      ...>         "[1518-11-03 00:29] wakes up",
      ...>         "[1518-11-04 00:36] falls asleep",
      ...>         "[1518-11-04 00:46] wakes up",
      ...>         "[1518-11-05 00:03] Guard #99 begins shift",
      ...>         "[1518-11-01 00:30] falls asleep",
      ...>         "[1518-11-01 00:55] wakes up",
      ...>         "[1518-11-04 00:02] Guard #99 begins shift",
      ...>         "[1518-11-02 00:50] wakes up",
      ...>         "[1518-11-03 00:05] Guard #10 begins shift",
      ...>         "[1518-11-03 00:24] falls asleep",
      ...>         "[1518-11-01 23:58] Guard #99 begins shift",
      ...>         "[1518-11-02 00:40] falls asleep",
      ...>         "[1518-11-05 00:45] falls asleep",
      ...>         "[1518-11-05 00:55] wakes up"]
      iex> AdventOfCode.Day04.solve("1", inp)
      240
      iex> AdventOfCode.Day04.solve("2", inp)
      4455
  """

  import AdventOfCode.Utils, only: [map_increment: 2]

  @spec solve(part :: String.t(), file_stream :: Stream.t()) :: integer
  def solve("1", file_stream) do
    do_solve(file_stream, &max_by_the_most_minutes_asleep/1)
  end

  @spec solve(part :: String.t(), file_stream :: Stream.t()) :: integer
  def solve("2", file_stream) do
    do_solve(file_stream, &max_by_the_most_frequent_minute/1)
  end

  defp max_by_the_most_frequent_minute({_guard_id, minutes}) do
    {_minute, number_of_days} = find_the_most_frequent_minute(minutes)
    number_of_days
  end

  defp max_by_the_most_minutes_asleep({_guard_id, minutes}) do
    Enum.reduce(minutes, 0, fn {_minute, number_of_days}, acc -> acc + number_of_days end)
  end

  defp do_solve(file_stream, max_by_fun) do
    {guard_id, minute} =
      file_stream
      |> Enum.sort()
      |> Stream.map(&__MODULE__.LogParser.parse/1)
      |> Enum.reduce({%{}, nil, nil}, &reduce_log_record_into_guards_stats/2)
      |> elem(0)
      |> find_guard_and_minute(max_by_fun)

    guard_id * minute
  end

  defp find_guard_and_minute(stats, max_by_fun) do
    {guard_id, minutes} = Enum.max_by(stats, max_by_fun)
    {minute, _number_of_days} = find_the_most_frequent_minute(minutes)

    {guard_id, minute}
  end

  defp find_the_most_frequent_minute(minutes) do
    Enum.max_by(minutes, fn {_minute, number_of_days} -> number_of_days end)
  end

  defp reduce_log_record_into_guards_stats({minute, {:begins_shift, new_guard_id}}, {stats, _, _}) do
    {stats, new_guard_id, {:awake, minute}}
  end

  defp reduce_log_record_into_guards_stats({minute, :falls_asleep}, {stats, guard_id, {:awake, _since_minute}}) do
    {stats, guard_id, {:asleep, minute}}
  end

  defp reduce_log_record_into_guards_stats({minute, :wakes_up}, {stats, guard_id, {:asleep, since_minute}}) do
    {do_update_guard_stats(stats, guard_id, since_minute, minute - 1), guard_id, {:awake, minute}}
  end

  defp reduce_log_record_into_guards_stats({_minute, event}, {_stats, guard_id, guard_state}) do
    raise ArgumentError, "Got #{event} event when guard##{guard_id} is in #{inspect(guard_state)} state"
  end

  defp do_update_guard_stats(stats, guard_id, from_minute, to_minute) do
    Enum.reduce(from_minute..to_minute, stats, fn minute, stats ->
      guard_stats = Map.get(stats, guard_id, %{})
      Map.put(stats, guard_id, map_increment(guard_stats, minute))
    end)
  end
end
