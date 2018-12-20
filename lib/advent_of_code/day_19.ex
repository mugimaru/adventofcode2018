defmodule AdventOfCode.Day19 do
  @moduledoc ~S"""
  [Advent Of Code day 19](https://adventofcode.com/2018/day/19).
  """
  alias AdventOfCode.Day16.Ops

  def solve("1", input) do
    do_solve(input, 0)
  end

  def solve("2", input) do
    do_solve(input, 1)
  end

  defp do_solve(input, first_reg_value) do
    {ip_binding, instructions} = parse_input(input)
    instructions_count = Enum.count(instructions)

    initial_reg = %{0 => first_reg_value, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0}

    Enum.reduce_while(Stream.iterate(1, &(&1 + 1)), {initial_reg, 0}, fn _step, {reg, ip_value} ->
      reg =
        reg
        |> Map.put(ip_binding, ip_value)
        |> apply_op(instructions[ip_value])

      ip_value = reg[ip_binding] + 1

      if ip_value >= instructions_count, do: {:halt, reg}, else: {:cont, {reg, ip_value}}
    end)
    |> Map.get(0)
  end

  defp apply_op(reg, {opcode, args}), do: Ops.op(opcode, args, reg)

  defp parse_input(input) do
    ["#ip " <> n | instr] = String.split(input, "\n")

    res =
      instr
      |> Enum.with_index()
      |> Enum.into(%{}, fn {line, i} ->
        [opcode | args] = String.split(line, " ")
        {i, {String.to_atom(opcode), Enum.map(args, &String.to_integer/1)}}
      end)

    {String.to_integer(n), res}
  end
end
