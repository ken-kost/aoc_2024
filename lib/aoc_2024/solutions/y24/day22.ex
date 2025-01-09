defmodule Aoc2024.Solutions.Y24.Day22 do
  import Bitwise

  alias AoC.Input

  def parse(input, _part), do: input

  def part_one(problem) do
    problem
    |> Input.stream!(trim: true)
    |> Stream.map(fn secret ->
      secret
      |> String.to_integer()
      |> Stream.iterate(&next_secret/1)
      |> Stream.drop(2000)
      |> Enum.take(1)
      |> hd()
    end)
    |> Enum.sum()
  end

  defp next_secret(secret, mask \\ 16_777_215) do
    secret = band(bxor(secret <<< 6, secret), mask)
    secret = band(bxor(secret >>> 5, secret), mask)
    band(bxor(secret <<< 11, secret), mask)
  end

  # def part_two(problem) do
  #   problem
  # end
end
