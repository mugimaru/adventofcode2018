defmodule AdventOfCode.Day04 do
  @moduledoc ~S"""
  [Advent Of Code day 4](https://adventofcode.com/2018/day/4).

  # Part 1
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
  """

  alias __MODULE__.LogParser

  import AdventOfCode.Utils, only: [map_increment: 2]

  @spec solve(part :: String.t(), file_stream :: Stream.t()) :: integer
  def solve("1", file_stream) do
    {guard_id, minutes} =
      file_stream
      |> Stream.map(&LogParser.parse/1)
      |> Enum.sort_by(fn {date, h, m, _} -> {date, h, m} end)
      |> Enum.reduce({%{}, nil, nil}, &do_reduce_by_date/2)
      |> elem(0)
      |> find_guard_with_the_most_minutes_asleep()

    {minute, _} = Enum.reduce(minutes, %{}, &map_increment(&2, &1)) |> Enum.max_by(fn {_k, v} -> v end)

    guard_id * minute
  end

  defp find_guard_with_the_most_minutes_asleep(stats_by_date) do
    Enum.reduce(stats_by_date, %{}, fn {_day, {guard_id, minutes}}, map ->
      Map.get_and_update(map, guard_id, fn
        nil ->
          {nil, minutes}

        data ->
          {data, data ++ minutes}
      end)
      |> elem(1)
    end)
    |> Enum.max_by(fn {_guard_id, minutes} -> Enum.count(minutes) end)
  end

  defp do_reduce_by_date({_day, _hour, minute, {:begins_shift, new_guard_id}}, {logs, _, _}) do
    {logs, new_guard_id, {:awake, minute}}
  end

  defp do_reduce_by_date({day, _hour, minute, :wakes_up}, {logs, guard_id, {:asleep, since_minute}}) do
    {update_logs(logs, day, guard_id, since_minute, minute), guard_id, {:awake, minute}}
  end

  defp do_reduce_by_date({_day, _hour, minute, :falls_asleep}, {logs, guard_id, {:awake, _since_minute}}) do
    {logs, guard_id, {:asleep, minute}}
  end

  defp update_logs(logs, day, guard_id, from, to) do
    {^guard_id, minutes_asleep} = Map.get(logs, day, {guard_id, []})
    Map.put(logs, day, {guard_id, minutes_asleep ++ Enum.into(from..to, [])})
  end
end
