defmodule AdventOfCode.Day07 do
  @moduledoc ~S"""
  [Advent Of Code day 7](https://adventofcode.com/2018/day/7).

    iex> input = [
    ...>  "Step C must be finished before step A can begin.",
    ...>  "Step C must be finished before step F can begin.",
    ...>  "Step A must be finished before step B can begin.",
    ...>  "Step A must be finished before step D can begin.",
    ...>  "Step B must be finished before step E can begin.",
    ...>  "Step D must be finished before step E can begin.",
    ...>  "Step F must be finished before step E can begin."]
    iex> AdventOfCode.Day07.solve("1", input)
    "CABDFE"
    iex>AdventOfCode.Day07.solve("2", input)
    15
  """

  defmodule Workers do
    @number_of_workers if Mix.env() == :test, do: 2, else: 5
    @base_time if Mix.env() == :test, do: 0, else: 60
    @task_durations_map ?A..?Z |> Enum.with_index(@base_time + 1) |> Enum.into(%{}, fn {char, i} -> {to_string([char]), i} end)

    def new do
      Enum.map(1..@number_of_workers, fn _ -> {:idle, 0} end)
    end

    def count_idle(workers), do: Enum.count(workers, fn {task, _} -> task == :idle end)

    # expects no idle workers
    def finish_shortest_task(workers) do
      {task, min_time} = Enum.filter(workers, fn {task, _} -> task != :idle end) |> Enum.min_by(fn {_, time} -> time end)

      updated_workers =
        Enum.map(workers, fn {task, time} ->
          case time - min_time do
            0 ->
              {:idle, 0}

            time ->
              {task, time}
          end
        end)

      {task, min_time, updated_workers}
    end

    def finish_all(workers) do
      {_task, max_time} = Enum.max_by(workers, fn {_, time} -> time end)
      {max_time, new()}
    end

    def assign_tasks(workers, tasks) do
      Enum.map_reduce(workers, tasks, &do_assign_tasks/2) |> elem(0)
    end

    defp do_assign_tasks(worker, []), do: {worker, []}
    defp do_assign_tasks({:idle, _}, [task | rest]), do: {{task, time_to_complete(task)}, rest}
    defp do_assign_tasks(worker, tasks), do: {worker, tasks}

    defp time_to_complete(task), do: @task_durations_map[task]
  end

  def solve("1", input) do
    requirements = input_into_requirements_map(input)

    {reversed_sequence, _} =
      Enum.reduce(1..Enum.count(requirements), {[], requirements}, fn _, {acc, requirements} ->
        {next_step, _} = Enum.min_by(requirements, fn {step, preq_list} -> {Enum.count(preq_list), step} end)

        requirements =
          Map.delete(requirements, next_step) |> Enum.into(%{}, fn {step, preq_list} -> {step, List.delete(preq_list, next_step)} end)

        {[next_step | acc], requirements}
      end)

    reversed_sequence |> Enum.reverse() |> Enum.join()
  end

  def solve("2", input) do
    requirements = input_into_requirements_map(input)

    {time, _, %{}} =
      Enum.reduce_while(Stream.cycle([nil]), {0, Workers.new(), requirements}, fn _, {time_acc, workers, requirements} ->
        tasks = available_tasks(requirements)
        idle_workers = Workers.count_idle(workers)

        {time, workers, requirements} =
          if tasks == [] || idle_workers == 0 do
            {task, time_spent, workers} = Workers.finish_shortest_task(workers)
            {time_acc + time_spent, workers, drop_dependency_from_tasks(requirements, [task])}
          else
            tasks_to_assign = Enum.take(tasks, idle_workers)
            workers = Workers.assign_tasks(workers, tasks_to_assign)

            {time_acc, workers, delete_tasks(requirements, tasks_to_assign)}
          end

        case Enum.count(requirements) do
          0 ->
            {time_spent, workers} = Workers.finish_all(workers)
            {:halt, {time + time_spent, workers, %{}}}

          _ ->
            {:cont, {time, workers, requirements}}
        end
      end)

    time
  end

  defp available_tasks(requirements) do
    requirements
    |> Enum.filter(fn {_, req} -> req == [] end)
    |> Enum.sort_by(fn {task, _} -> task end)
    |> Enum.map(fn {task, _} -> task end)
  end

  defp delete_tasks(requirements, tasks) when is_list(tasks) do
    Enum.filter(requirements, fn {task, _} -> task not in tasks end) |> Enum.into(%{})
  end

  defp drop_dependency_from_tasks(requirements, tasks_to_delete) when is_list(tasks_to_delete) do
    Enum.reduce(requirements, %{}, fn {task, blockers}, acc ->
      if task in tasks_to_delete do
        Map.put(acc, task, [])
      else
        case blockers -- tasks_to_delete do
          [] ->
            Map.put(acc, task, [])

          rest ->
            Map.put(acc, task, rest)
        end
      end
    end)
  end

  defp input_into_requirements_map(input) when is_binary(input) do
    input |> String.split("\n") |> input_into_requirements_map()
  end

  defp input_into_requirements_map(input) do
    Enum.reduce(input, %{}, fn line, acc ->
      <<"Step ", a::binary-size(1), " must be finished before step ", b::binary-size(1), " can begin.">> = line

      acc
      |> Map.update(b, [a], &[a | &1])
      |> Map.put_new(a, [])
    end)
  end
end
