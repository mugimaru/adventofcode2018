defmodule AdventOfCode.Day04.LogParser do
  @moduledoc "Day 4 events log parser. See `AdventOfCode.Day04`"

  @regex ~r/\[(?<day>\d\d\d\d-\d\d-\d\d+) (?<hour>\d\d):(?<minute>\d\d)\] (?<msg>.+)/

  @type event_data :: :wakes_up | :falls_asleep | {:begins_shift, guard_id :: integer}
  @type event :: {minute :: integer, event_data()}

  @spec parse(line :: String.t()) :: event()
  def parse(line) do
    case Regex.named_captures(@regex, line) do
      nil ->
        raise ArgumentError, "invalid input line"

      %{"msg" => msg, "minute" => minute} ->
        {String.to_integer(minute), parse_event_data(msg)}
    end
  end

  defp parse_event_data(msg) do
    case msg do
      "wakes up" ->
        :wakes_up

      "falls asleep" ->
        :falls_asleep

      msg ->
        {:begins_shift, guard_id_from_begins_shift_msg(msg)}
    end
  end

  defp guard_id_from_begins_shift_msg(begins_shift_msg) do
    begins_shift_msg |> String.replace(~r/\D/, "") |> String.to_integer()
  end
end
