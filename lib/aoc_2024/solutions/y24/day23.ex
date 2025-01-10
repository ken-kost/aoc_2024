defmodule Aoc2024.Solutions.Y24.Day23 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(fn line -> line |> String.split("-") |> List.to_tuple() end)
  end

  def part_one(problem) do
    map =
      problem
      |> Enum.reduce(%{}, fn {a, b}, map ->
        map
        |> Map.update(a, MapSet.new([b]), fn set -> MapSet.put(set, b) end)
        |> Map.update(b, MapSet.new([a]), fn set -> MapSet.put(set, a) end)
      end)

    Enum.reduce(map, MapSet.new(), fn {key, values}, acc ->
      values
      |> Enum.reduce(MapSet.new(), fn value, acc ->
        map
        |> Map.get(value)
        |> then(fn other_values ->
          other_values
          |> Enum.filter(&(key in other_values and &1 in values))
          |> Enum.reduce(acc, &MapSet.put(&2, Enum.sort([key, value, &1])))
        end)
      end)
      |> MapSet.union(acc)
    end)
    |> dbg()
    |> Enum.filter(&Enum.any?(&1, fn e -> String.contains?(e, "t") end))
    |> Enum.count()
  end
end
