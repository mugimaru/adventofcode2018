defmodule AdventOfCode.Day16 do
  @moduledoc ~S"""
  [Advent Of Code day 16](https://adventofcode.com/2018/day/16).
  """

  alias __MODULE__.Ops

  def solve("1", {raw_samples, _}) do
    samples = parse_samples(raw_samples)
    Enum.count(samples, fn sample -> Enum.count(opcodes_match(sample)) >= 3 end)
  end

  def solve("2", {raw_samples, ops}) do
    opcodes_map = resolve_opcodes_map(raw_samples)

    ops
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(reg_to_map([0, 0, 0, 0]), fn [op_id | op_args], reg ->
      Map.get(opcodes_map, op_id) |> Ops.op(op_args, reg)
    end)
    |> Enum.map(&elem(&1, 1))
    |> hd()
  end

  @doc ~S"""
      iex> opcodes_match([[3, 2, 1, 1], [9, 2, 1, 2], [3, 2, 2, 1]])
      [:addi, :mulr, :seti]
  """
  def opcodes_match(sample), do: opcodes_match(sample, Ops.codes())

  def opcodes_match([reg_before, [_op_id | op_args], reg_after], candidates) do
    ra = reg_to_map(reg_after)
    Enum.filter(candidates, fn c -> Ops.op(c, op_args, reg_to_map(reg_before)) == ra end)
  end

  defp resolve_opcodes_map(raw_samples) do
    raw_samples
    |> parse_samples()
    |> opcodes_map_from_samples()
    |> resolve([])
    |> Enum.into(%{})
  end

  defp opcodes_map_from_samples(samples) do
    candidates_map = Enum.into(0..(Enum.count(Ops.codes()) - 1), %{}, fn i -> {i, Ops.codes()} end)

    Enum.reduce(samples, candidates_map, fn [_, [op_id | _], _] = sample, candidates_map ->
      case Map.get(candidates_map, op_id) do
        [_] ->
          candidates_map

        candidates ->
          Map.put(candidates_map, op_id, opcodes_match(sample, candidates))
      end
    end)
  end

  defp resolve(opcodes_map, resolved) do
    {id, [opcode]} = Enum.find(opcodes_map, fn {_id, opcodes} -> Enum.count(opcodes) == 1 end)
    resolved = [{id, opcode} | resolved]

    if Enum.count(resolved) == Ops.count(), do: resolved, else: drop_candidate(opcode, opcodes_map) |> resolve(resolved)
  end

  defp drop_candidate(candidate, opcodes_map) do
    Enum.map(opcodes_map, fn {id, opcodes} -> {id, List.delete(opcodes, candidate)} end)
  end

  defp reg_to_map([a, b, c, d]), do: %{0 => a, 1 => b, 2 => c, 3 => d}

  defp parse_samples(samples), do: String.split(samples, "\n\n") |> Enum.map(&parse_sample/1)

  defp parse_sample(sample), do: sample |> String.split("\n") |> Enum.map(&parse_line/1)

  defp parse_line(str), do: Regex.scan(~r/\d+/, str) |> Enum.map(fn [v] -> String.to_integer(v) end)
end
