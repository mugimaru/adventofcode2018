defmodule AdventOfCode.Day12 do
  @moduledoc ~S"""
  [Advent Of Code day 12](https://adventofcode.com/2018/day/12).

      iex> parse_rule("...## => #")
      {[0, 0, 0, 1, 1], 1}

      iex> parse_rule(".##.# => .")
      {[0, 1, 1, 0, 1], 0}

      iex> input = Enum.join([
      ...>   "initial state: #..#.#..##......###...###",
      ...>   "",
      ...>   "...## => #",
      ...>   "..#.. => #",
      ...>   ".#... => #",
      ...>   ".#.#. => #",
      ...>   ".#.## => #",
      ...>   ".##.. => #",
      ...>   ".#### => #",
      ...>   "#.#.# => #",
      ...>   "#.### => #",
      ...>   "##.#. => #",
      ...>   "##.## => #",
      ...>   "###.. => #",
      ...>   "###.# => #",
      ...>   "####. => #"
      ...> ], "\n")
      iex> {first_gen, rules} = parse_input(input)
      {
        [1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1],
        %{
          [0, 0, 0, 1, 1] => 1,
          [0, 0, 1, 0, 0] => 1,
          [0, 1, 0, 0, 0] => 1,
          [0, 1, 0, 1, 0] => 1,
          [0, 1, 0, 1, 1] => 1,
          [0, 1, 1, 0, 0] => 1,
          [0, 1, 1, 1, 1] => 1,
          [1, 0, 1, 0, 1] => 1,
          [1, 0, 1, 1, 1] => 1,
          [1, 1, 0, 1, 0] => 1,
          [1, 1, 0, 1, 1] => 1,
          [1, 1, 1, 0, 0] => 1,
          [1, 1, 1, 0, 1] => 1,
          [1, 1, 1, 1, 0] => 1
        }
      }
      iex> solve("1", input)
      325
  """

  @plant "#"
  @no_plant "."

  def solve("1", input) do
    {first_generation, rules} = parse_input(input)

    Enum.reduce(1..20, {first_generation, 0}, fn gen_index, {prev_gen, _prev_sum} ->
      current_gen = next_generation(prev_gen, rules)
      {current_gen, sum_pots_indexes(current_gen, gen_index)}
    end)
    |> elem(1)
  end

  @stable_after 20

  @doc ~s"""
  if sum of pots indexes changes by the same amount for #{@stable_after} sequential generations
  we consider its growth stable and use this amount to calculate the result instead of iterating further.
  """
  def solve("2", input) do
    {first_generation, rules} = parse_input(input)

    {gen_index, sum, diff} =
      Enum.reduce_while(Stream.iterate(1, &(&1 + 1)), {first_generation, 0, []}, fn gen_index, {prev_gen, prev_sum, diffs} ->
        current_gen = next_generation(prev_gen, rules)
        sum = sum_pots_indexes(current_gen, gen_index)
        sum_diff = sum - prev_sum

        if stable?(sum_diff, diffs) do
          {:halt, {gen_index, sum, sum_diff}}
        else
          {:cont, {current_gen, sum, [sum_diff | diffs]}}
        end
      end)

    IO.puts("Stable on generation #{gen_index} with diff=#{diff}")
    sum + (50_000_000_000 - gen_index) * diff
  end

  defp stable?(current_diff, all_diffs) do
    notable_diffs = Enum.take(all_diffs, @stable_after - 1)

    if Enum.count(notable_diffs) < @stable_after - 1 do
      false
    else
      Enum.all?(notable_diffs, fn diff -> diff == current_diff end)
    end
  end

  defp sum_pots_indexes(current_generation, generation_index) do
    current_generation
    |> Enum.with_index(generation_index * -2)
    |> Enum.reduce(0, fn {p, i}, acc -> if p == 1, do: acc + i, else: acc end)
  end

  defp next_generation(plants, rules) do
    next_generation([0, 0, 0, 0] ++ plants ++ [0, 0, 0, 0], rules, [])
  end

  defp next_generation([_, _, _, _], _rules, acc) do
    Enum.reverse(acc)
  end

  defp next_generation(plants, rules, acc) do
    {[_ | t] = current, rest} = Enum.split(plants, 5)
    next_generation(t ++ rest, rules, [Map.get(rules, current, 0) | acc])
  end

  def parse_input(input) do
    ["initial state: " <> first_generation, "" | rules] = String.split(input, "\n")
    first_gen = first_generation |> String.codepoints() |> Enum.map(&plant_marks_to_int/1)
    {first_gen, Enum.into(rules, %{}, &parse_rule/1)}
  end

  def parse_rule(<<rule::binary-size(5), " => "::utf8, result::binary-size(1)>>) do
    {rule |> String.codepoints() |> Enum.map(&plant_marks_to_int/1), plant_marks_to_int(result)}
  end

  defp plant_marks_to_int(@plant), do: 1
  defp plant_marks_to_int(@no_plant), do: 0
end
