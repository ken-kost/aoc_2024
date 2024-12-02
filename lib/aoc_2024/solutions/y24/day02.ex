defmodule Aoc2024.Solutions.Y24.Day02 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(fn line ->
      Enum.map(String.split(line, " "), fn part ->
        elem(Integer.parse(part), 0)
      end)
    end)
  end

  def part_one(problem) do
    Enum.reduce(problem, 0, fn [n1, n2 | _] = line, acc ->
      acc + check_levels(line, n1 < n2)
    end)
  end

  def part_two(problem) do
    Enum.reduce(problem, 0, fn line, acc ->
      Enum.reduce_while(0..(length(line) - 1), 0, fn i, acc ->
        [n1, n2 | _] = line = List.delete_at(line, i)

        case check_levels(line, n1 < n2) do
          1 -> {:halt, 1}
          0 -> {:cont, acc}
        end
      end) + acc
    end)
  end

  defp check_levels([_], _up?), do: 1

  defp check_levels([n1, n2 | rest], true) when n1 < n2 do
    if n2 - n1 <= 3, do: check_levels([n2 | rest], true), else: 0
  end

  defp check_levels([n1, n2 | rest], false) when n1 > n2 do
    if n1 - n2 <= 3, do: check_levels([n2 | rest], false), else: 0
  end

  defp check_levels(_, _), do: 0
end
