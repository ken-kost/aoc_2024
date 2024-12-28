defmodule Aoc2024.Solutions.Y24.Day18 do
  alias AoC.Input

  @max if Mix.env() == :test, do: 6, else: 70
  @number_of_bytes if Mix.env() == :test, do: 12, else: 1024

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Stream.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  def part_one(problem) do
    blocks = MapSet.new(Stream.take(problem, @number_of_bytes))
    {start, goal} = {{0, 0}, {@max, @max}}
    queue = :queue.from_list([{_steps = 0, start}])
    walk(queue, _seen = MapSet.new([start]), blocks, goal)
  end

  def part_two(problem) do
    {first, rest} = Enum.split(problem, @number_of_bytes)
    blocks = MapSet.new(first)
    {start, goal} = {{0, 0}, {@max, @max}}
    queue = :queue.from_list([{_steps = 0, start}])

    Enum.reduce_while(rest, blocks, fn next, blocks ->
      blocks = MapSet.put(blocks, next)

      case walk(queue, _seen = MapSet.new([start]), blocks, goal) do
        nil -> {:halt, next}
        _steps -> {:cont, blocks}
      end
    end)
  end

  defp walk(queue, seen, blocks, goal) do
    with {{steps, {x, y}}, queue} <- pop_queue(queue) do
      adjacents = [{x - 1, y}, {x, y - 1}, {x, y + 1}, {x + 1, y}]
      valid = Enum.filter(adjacents, &valid?(&1, seen, blocks))

      if goal in valid do
        steps + 1
      else
        seen = MapSet.union(seen, MapSet.new(valid))
        queue = Enum.reduce(valid, queue, &:queue.in({steps + 1, &1}, &2))
        walk(queue, seen, blocks, goal)
      end
    end
  end

  defp pop_queue(queue) do
    if(not :queue.is_empty(queue), do: {:queue.get(queue), :queue.drop(queue)})
  end

  defp valid?({x, y} = location, seen, blocks) do
    not MapSet.member?(seen, location) and
      not MapSet.member?(blocks, location) and
      x in 0..@max and y in 0..@max
  end
end
