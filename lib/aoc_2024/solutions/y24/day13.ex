defmodule Aoc2024.Solutions.Y24.Day13 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.read!()
    |> String.split("\n\n")
    |> Enum.map(fn block ->
      [a, b, p] = String.split(block, "\n", trim: true)
      %{a: extract_numbers(a), b: extract_numbers(b), p: extract_numbers(p)}
    end)
  end

  def part_one(problem) do
    problem
    |> Enum.map(fn %{a: a, b: b, p: p} -> play(a, b, p) end)
    |> Enum.sum()
  end

  def part_two(problem) do
    problem
    |> Enum.map(fn %{a: a, b: b, p: {xp, yp}} ->
      play(a, b, {xp + 10_000_000_000_000, yp + 10_000_000_000_000})
    end)
    |> Enum.sum()
  end

  defp play({xa, ya}, {xb, yb}, {xp, yp}) do
    # Solve the following equation system for integers:
    #
    #  xa * n + xb * m = xp
    #  ya * n + yb * m = yp
    #
    numerator = xa * yp - ya * xp
    denominator = xa * yb - ya * xb

    if rem(numerator, denominator) !== 0 do
      0
    else
      m = div(numerator, denominator)
      n = yp - yb * m

      if rem(n, ya) !== 0 do
        0
      else
        n = div(n, ya)
        3 * n + m
      end
    end
  end

  defp extract_numbers(string, regex \\ ~r/\d+(\.\d+)?/) do
    [[x], [y]] = Regex.scan(regex, string)
    {String.to_integer(x), String.to_integer(y)}
  end
end
