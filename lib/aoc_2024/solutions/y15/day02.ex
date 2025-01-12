defmodule Aoc2024.Solutions.Y15.Day02 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("x")
      |> Enum.map(&elem(Integer.parse(&1), 0))
    end)
  end

  def part_one(problem) do
    Enum.reduce(problem, 0, fn [l, w, h], acc ->
      calculations = [a, b, c] = [l * w, w * h, h * l]
      acc + 2 * a + 2 * b + 2 * c + Enum.min(calculations)
    end)
  end

  def part_two(problem) do
    Enum.reduce(problem, 0, fn [l, w, h] = list, acc ->
      [r1, r2, _] = Enum.sort(list)
      acc + r1 + r1 + r2 + r2 + l * w * h
    end)
  end
end
