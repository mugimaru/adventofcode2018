defmodule AdventOfCode.Day16.Ops do
  @opcodes [
    :addr,
    :addi,
    :mulr,
    :muli,
    :banr,
    :bani,
    :borr,
    :bori,
    :setr,
    :seti,
    :gtir,
    :gtri,
    :gtrr,
    :eqir,
    :eqri,
    :eqrr
  ]

  @opcodes_count Enum.count(@opcodes)

  def codes, do: @opcodes
  def count, do: @opcodes_count

  def op(:addr, [a, b, c], reg) do
    Map.put(reg, c, reg[a] + reg[b])
  end

  def op(:addi, [a, b, c], reg) do
    Map.put(reg, c, reg[a] + b)
  end

  def op(:mulr, [a, b, c], reg) do
    Map.put(reg, c, reg[a] * reg[b])
  end

  def op(:muli, [a, b, c], reg) do
    Map.put(reg, c, reg[a] * b)
  end

  def op(:banr, [a, b, c], reg) do
    Map.put(reg, c, :erlang.band(reg[a], reg[b]))
  end

  def op(:bani, [a, b, c], reg) do
    Map.put(reg, c, :erlang.band(reg[a], b))
  end

  def op(:borr, [a, b, c], reg) do
    Map.put(reg, c, :erlang.bor(reg[a], reg[b]))
  end

  def op(:bori, [a, b, c], reg) do
    Map.put(reg, c, :erlang.bor(reg[a], b))
  end

  def op(:setr, [a, _b, c], reg) do
    Map.put(reg, c, reg[a])
  end

  def op(:seti, [a, _b, c], reg) do
    Map.put(reg, c, a)
  end

  def op(:gtir, [a, b, c], reg) do
    Map.put(reg, c, gt(a, reg[b]))
  end

  def op(:gtri, [a, b, c], reg) do
    Map.put(reg, c, gt(reg[a], b))
  end

  def op(:gtrr, [a, b, c], reg) do
    Map.put(reg, c, gt(reg[a], reg[b]))
  end

  def op(:eqir, [a, b, c], reg) do
    Map.put(reg, c, eq(a, reg[b]))
  end

  def op(:eqri, [a, b, c], reg) do
    Map.put(reg, c, eq(reg[a], b))
  end

  def op(:eqrr, [a, b, c], reg) do
    Map.put(reg, c, eq(reg[a], reg[b]))
  end

  defp gt(a, b) when a > b, do: 1
  defp gt(_a, _b), do: 0

  defp eq(a, a), do: 1
  defp eq(_a, _b), do: 0
end
