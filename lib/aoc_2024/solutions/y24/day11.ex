defmodule Aoc2024.Solutions.Y24.Day11 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.read!()
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, String.to_integer(x), 1, &(&1 + 1)) end)
  end

  def part_one(stones) do
    blinker(stones, 25) |> Map.values() |> Enum.sum()
  end

  def part_two(stones) do
    blinker(stones, 75) |> Map.values() |> Enum.sum()
  end

  defp blinker(stones, 0), do: stones

  defp blinker(stones, n) do
    stones
    |> Map.to_list()
    |> blink(%{})
    |> blinker(n - 1)
  end

  def blink([], acc), do: acc

  def blink([{0, n} | rest], acc) do
    blink(rest, Map.update(acc, 1, n, &(&1 + n)))
  end

  def blink([{x, n} | rest], acc) do
    digits = Integer.digits(x)

    case rem(Enum.count(digits), 2) do
      0 ->
        blink(rest, update_even(digits, n, acc))

      1 ->
        blink(rest, Map.update(acc, x * 2024, n, &(&1 + n)))
    end
  end

  defp update_even(digits, n, acc) do
    {a, b} = Enum.split(digits, div(Enum.count(digits), 2))

    acc
    |> Map.update(Integer.undigits(a), n, &(&1 + n))
    |> Map.update(Integer.undigits(b), n, &(&1 + n))
  end
end
