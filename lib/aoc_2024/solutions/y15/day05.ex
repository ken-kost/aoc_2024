defmodule Aoc2024.Solutions.Y15.Day05 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(&String.codepoints/1)
  end

  def part_one(problem) do
    count_nice_strings(problem, 0)
  end

  def part_two(problem) do
    count_nice_strings_two(problem, 0)
  end

  defp count_nice_strings([], acc), do: acc

  defp count_nice_strings([head | rest], acc) do
    acc = if is_nice?(head), do: acc + 1, else: acc
    count_nice_strings(rest, acc)
  end

  defp count_nice_strings_two([], acc), do: acc

  defp count_nice_strings_two([head | rest], acc) do
    acc = if is_nice_two?(head), do: acc + 1, else: acc
    count_nice_strings_two(rest, acc)
  end

  defp is_nice?(line) do
    at_least_3_vowels?(line) and at_least_one_letter_twice?(line) and no_invalid_strings?(line)
  end

  defp is_nice_two?(line) do
    any_two_appear_twice?(line) and at_least_one_letter_that_repeats_with_one_between?(line)
  end

  defp at_least_3_vowels?(line) do
    Enum.reduce(line, 0, fn e, acc ->
      if e in ["a", "e", "i", "o", "u"], do: acc + 1, else: acc
    end) >= 3
  end

  defp any_two_appear_twice?([]), do: false

  defp any_two_appear_twice?([x, y | rest]) do
    if String.contains?(Enum.into(rest, ""), "#{x}#{y}") do
      true
    else
      any_two_appear_twice?([y | rest])
    end
  end

  defp any_two_appear_twice?([_head | rest]) do
    any_two_appear_twice?(rest)
  end

  defp at_least_one_letter_twice?([]), do: false
  defp at_least_one_letter_twice?([x, x | _rest]), do: true
  defp at_least_one_letter_twice?([_head | rest]), do: at_least_one_letter_twice?(rest)

  defp no_invalid_strings?([]), do: true
  defp no_invalid_strings?(["a", "b" | _]), do: false
  defp no_invalid_strings?(["c", "d" | _]), do: false
  defp no_invalid_strings?(["p", "q" | _]), do: false
  defp no_invalid_strings?(["x", "y" | _]), do: false
  defp no_invalid_strings?([_ | rest]), do: no_invalid_strings?(rest)

  defp at_least_one_letter_that_repeats_with_one_between?([]), do: false
  defp at_least_one_letter_that_repeats_with_one_between?([x, _y, x | _rest]), do: true

  defp at_least_one_letter_that_repeats_with_one_between?([_head | rest]) do
    at_least_one_letter_that_repeats_with_one_between?(rest)
  end
end
