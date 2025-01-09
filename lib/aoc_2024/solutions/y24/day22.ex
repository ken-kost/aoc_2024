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

  def part_two(problem) do
    problem
    |> Input.stream!(trim: true)
    |> Enum.reduce(%{}, fn secret, sales ->
      secret
      |> String.to_integer()
      |> Stream.iterate(&next_secret/1)
      |> Stream.map(&rem(&1, 10))
      |> Stream.chunk_every(2, 1)
      |> Stream.map(fn [a, b] -> {b - a, b} end)
      |> Enum.take(2000)
      |> Enum.chunk_every(4, 1, :discard)
      |> Enum.flat_map(fn seq ->
        [_, _, _, {_, price}] = seq
        # Optimization: compress the sequence.
        seq =
          Enum.map(seq, &elem(&1, 0))
          |> Enum.reduce(0, fn item, acc ->
            acc * 20 + (item + 10)
          end)

        [{seq, price}]
      end)
      |> Enum.uniq_by(&elem(&1, 0))
      |> Enum.reduce(sales, fn {seq, price}, sales ->
        Map.update(sales, seq, price, &(&1 + price))
      end)
    end)
    |> Enum.max_by(fn {_, total_price} -> total_price end)
    |> elem(1)
  end

  defp next_secret(secret, mask \\ 16_777_215) do
    secret = band(bxor(secret <<< 6, secret), mask)
    secret = band(bxor(secret >>> 5, secret), mask)
    band(bxor(secret <<< 11, secret), mask)
  end
end
