defmodule Aoc2024.Solutions.Y24.Day10 do
  alias AoC.Input

  def parse(input, part) do
    input
    |> Input.stream!(trim: true)
    |> Stream.with_index()
    |> Enum.reduce({[], %{}}, fn {line, x}, {trailheads, map} ->
      line
      |> String.codepoints()
      |> Stream.with_index()
      |> Enum.reduce({trailheads, map}, fn
        {e, y}, {trailheads, map} ->
          case String.to_integer(e) do
            0 -> {[{x, y} | trailheads], map}
            n -> {trailheads, Map.put(map, {x, y}, n)}
          end
      end)
    end)
    |> Tuple.append(if(part == :part_one, do: MapSet.new(), else: 0))
  end

  def part_one({trailheads, map, init}) do
    solver(trailheads, map, init, 0)
  end

  def part_two({trailheads, map, init}) do
    solver(trailheads, map, init, 0)
  end

  defp solver([], _map, _init, acc), do: acc

  defp solver([{x, y} | rest], map, init, acc) when is_map(init) do
    result = follow_trails(x, y, map, 0, init)
    solver(rest, map, init, acc + MapSet.size(result))
  end

  defp solver([{x, y} | rest], map, init, acc) do
    result = follow_trails(x, y, map, 0, init)
    solver(rest, map, init, acc + result)
  end

  defp follow_trails(x, y, map, n, acc) do
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    |> Enum.reduce([], fn point, acc ->
      value = Map.get(map, point)
      if value == n + 1, do: [{point, value} | acc], else: acc
    end)
    |> Enum.reduce(acc, fn
      {point, 9}, acc ->
        if is_map(acc), do: MapSet.put(acc, point), else: acc + 1

      {{next_x, next_y}, _value}, acc ->
        follow_trails(next_x, next_y, map, n + 1, acc)
    end)
  end
end
