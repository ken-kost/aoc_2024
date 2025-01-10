defmodule Aoc2024.Solutions.Y15.Day01 do
  alias AoC.Input

  def parse(input, _part) do
    input |> Input.read!() |> String.to_charlist()
  end

  def part_one(problem) do
    Enum.reduce(problem, 0, fn
      40, acc -> acc + 1
      41, acc -> acc - 1
    end)
  end

  def part_two(problem) do
    Enum.reduce_while(problem, {0, 0}, fn
      _e, {-1, index} -> {:halt, index}
      40, {floor, index} -> {:cont, {floor + 1, index + 1}}
      41, {floor, index} -> {:cont, {floor - 1, index + 1}}
    end)
  end
end
