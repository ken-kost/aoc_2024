defmodule Aoc2024.Solutions.Y24.Day04 do
  alias AoC.Input

  def parse(input, part) do
    input =
      input
      |> Input.stream!(trim: true)
      |> Enum.map(&String.codepoints(&1 <> "YYY"))
      |> (fn input -> input ++ padding(length(hd(input))) end).()

    n = if part == :part_one, do: 4, else: 3

    for x <- 0..(length(input) - n), y <- 0..(length(hd(input)) - n) do
      {_, rest_x} = Enum.split(input, x)
      rest_rows = Enum.take(rest_x, n)

      Enum.map(rest_rows, fn rest_row ->
        {_, rest_y} = Enum.split(rest_row, y)
        Enum.take(rest_y, n)
      end)
    end
  end

  def part_one(problem), do: Enum.reduce(problem, 0, &(&2 + count_xmas(&1)))

  def part_two(problem), do: Enum.reduce(problem, 0, &(&2 + count_mas(&1)))

  defp count_xmas([[a1, a2, a3, a4], [b1, b2, b3, _b4], [c1, c2, c3, _c4], [d1, _d2, _d3, d4]]) do
    list = [
      a1 <> a2 <> a3 <> a4,
      a1 <> b1 <> c1 <> d1,
      a1 <> b2 <> c3 <> d4,
      a4 <> b3 <> c2 <> d1
    ]

    Enum.reduce(list, 0, fn e, acc ->
      case e do
        "XMAS" -> acc + 1
        "SAMX" -> acc + 1
        _ -> acc
      end
    end)
  end

  defp count_mas([[a1, _a2, a3], [_b1, b2, _b3], [c1, _c3, c3]]) do
    case b2 <> a1 <> a3 <> c1 <> c3 do
      "AMMSS" -> 1
      "ASSMM" -> 1
      "ASMSM" -> 1
      "AMSMS" -> 1
      _ -> 0
    end
  end

  defp padding(n) do
    for _ <- 0..2 do
      for _ <- 0..(n - 1) do
        "Y"
      end
    end
  end
end
