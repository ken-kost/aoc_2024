defmodule Aoc2024.Solutions.Y24.Day20 do
  alias AoC.Input

  @limit 100
  @cheat_steps 2

  def parse(input, _part) do
    map =
      input
      |> Input.stream!(trim: true)
      |> Stream.with_index()
      |> Enum.flat_map(fn {line, x} ->
        line
        |> String.to_charlist()
        |> Stream.with_index()
        |> Enum.map(fn {c, y} -> {{x, y}, c} end)
      end)
      |> Map.new()

    {start, ?S} = Enum.find(map, &(elem(&1, 1) === ?S))
    {finish, ?E} = Enum.find(map, &(elem(&1, 1) === ?E))

    map = %{map | start => ?., finish => ?.}

    {map, start, finish}
  end

  def part_one({map, start, finish}) do
    map
    |> steps_to_finish(start, finish, _seen = MapSet.new())
    |> then(fn
      steps_to_finish -> Enum.map(steps_to_finish, &count_cheats(&1, steps_to_finish))
    end)
    |> Enum.sum()
  end

  defp steps_to_finish(map, start, finish, seen) do
    map
    |> walk_to_finish(start, finish, seen)
    |> elem(1)
    |> Map.new()
  end

  defp walk_to_finish(_map, finish, finish, _seen), do: {1, [{finish, 0}]}

  defp walk_to_finish(map, {x, y} = location, finish, seen) do
    adjacents = [{x - 1, y}, {x, y - 1}, {x, y + 1}, {x + 1, y}]
    next = Enum.find(adjacents, &(Map.get(map, &1) == ?. and not MapSet.member?(seen, &1)))
    seen = MapSet.put(seen, next)
    {steps, acc} = walk_to_finish(map, next, finish, seen)
    {steps + 1, [{location, steps} | acc]}
  end

  defp count_cheats({{x, y} = location, max_steps}, steps_to_finish) do
    Enum.reduce((x - @cheat_steps)..(x + @cheat_steps), 0, fn x, count ->
      Enum.reduce((y - @cheat_steps)..(y + @cheat_steps), count, fn y, count ->
        distance = manhattan_distance({x, y}, location)

        cond do
          {x, y} == location -> count
          distance > @cheat_steps -> count
          not acceptable?(steps_to_finish, max_steps).({x, y}, distance) -> count
          true -> count + 1
        end
      end)
    end)
  end

  defp acceptable?(steps_to_finish, max_steps) do
    fn location, distance ->
      case steps_to_finish do
        %{^location => steps} ->
          saved = max_steps - steps - distance
          saved >= @limit

        %{} ->
          false
      end
    end
  end

  defp manhattan_distance({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)

  # def part_two(problem) do
  #   problem
  # end
end
