defmodule Aoc2024.Solutions.Y15.Day04 do
  alias AoC.Input

  def parse(input, _part) do
    input |> Input.read!() |> String.trim()
  end

  def part_one(problem) do
    find_zero_hash(problem, 0)
  end

  def part_two(problem) do
    find_zero_hash_strict(problem, 0)
  end

  defp find_zero_hash(problem, counter) do
    case :crypto.hash(:md5, problem <> "#{counter}") do
      <<0, 0, x, _rest::binary>> when x >= 0 and x <= 15 ->
        counter

      _ ->
        find_zero_hash(problem, counter + 1)
    end
  end

  defp find_zero_hash_strict(problem, counter) do
    case :crypto.hash(:md5, problem <> "#{counter}") do
      <<0, 0, 0, _rest::binary>> ->
        counter

      _ ->
        find_zero_hash_strict(problem, counter + 1)
    end
  end
end
