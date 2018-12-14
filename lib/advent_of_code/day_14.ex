defmodule AdventOfCode.Day14 do
  @moduledoc ~S"""
  [Advent Of Code day 14](https://adventofcode.com/2018/day/14).
  """

  defmodule Recipes do
    use GenServer

    defstruct [:scores, :elves, :last_index, :iterations]
    @type t :: %__MODULE__{scores: Map.t(), elves: [non_neg_integer], last_index: non_neg_integer}

    def start_link(input) do
      GenServer.start_link(__MODULE__, input, name: __MODULE__)
    end

    def init(input) do
      scores =
        input
        |> split_score()
        |> Enum.with_index(1)
        |> Enum.into(%{}, fn {score, i} -> {i, score} end)

      struct = struct(__MODULE__, scores: scores, elves: [1, 2], last_index: Enum.count(scores), iterations: 0)
      {:ok, struct}
    end

    # API

    @timeout 50_000
    def show_scoreboard(n), do: GenServer.call(__MODULE__, {:show_scoreboard, n}, @timeout)
    def iterate, do: GenServer.cast(__MODULE__, :iterate)
    def print, do: GenServer.call(__MODULE__, :print, @timeout)

    # CALLBACKS

    def handle_call(:print, _, state) do
      {:reply, do_print(state), state}
    end

    def handle_call({:show_scoreboard, n}, _, state) do
      {:reply, do_get_scoreboard((n + 1)..(n + 10), state.scores), state}
    end

    def handle_cast(:iterate, state) do
      {:noreply, do_iterate(state)}
    end

    # IMPLEMENTATION

    defp do_print(%{elves: [first, second], scores: scores}) do
      Enum.map(scores, fn {i, s} ->
        cond do
          i == first -> "(#{s})"
          i == second -> "[#{s}]"
          true -> " #{s} "
        end
      end)
      |> Enum.join(" ")
    end

    defp do_get_scoreboard(range, scores) do
      range
      |> Enum.map(fn i -> Map.get(scores, i) end)
      |> Enum.join()
    end

    defp do_iterate(%{elves: [first, second]} = state) do
      st =
        (Map.get(state.scores, first) + Map.get(state.scores, second))
        |> split_score()
        |> Enum.reduce(state, fn score, st ->
          %{state | last_index: st.last_index + 1, scores: Map.put(st.scores, st.last_index + 1, score)}
        end)

      %{st | elves: move_elves(st), iterations: st.iterations + 1}
    end

    defp move_elves(%{elves: elves, last_index: li, scores: scores}) do
      Enum.map(elves, fn e ->
        case rem(e + Map.get(scores, e) + 1, li) do
          0 -> li
          n -> n
        end
      end)
    end

    defp split_score(int), do: int |> to_string() |> String.codepoints() |> Enum.map(&String.to_integer/1)
  end

  def solve("1", iterations) do
    Recipes.start_link(37)
    1..(iterations + 10) |> Enum.each(fn _ -> Recipes.iterate() end)
    Recipes.show_scoreboard(iterations)
  end
end
