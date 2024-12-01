defmodule Aoc2024.Solutions.Y24.Day01 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!()
    |> Enum.reduce({[], []}, fn line, acc ->
      {acc1, acc2} = acc
      {num1, num2} = parse_line(line)
      {Enum.sort([num1 | acc1]), Enum.sort([num2 | acc2])}
    end)
  end

  def part_one({list1, list2}) do
    Enum.reduce(Stream.zip(list1, list2), 0, fn {num1, num2}, acc -> abs(num1 - num2) + acc end)
  end

  def part_two({list1, list2}) do
    Enum.reduce(list1, 0, fn num, acc -> count_number(list2, num, 0) * num + acc end)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split()
    |> then(fn [num1, num2] ->
      {num1, _} = Integer.parse(num1)
      {num2, _} = Integer.parse(num2)
      {num1, num2}
    end)
  end

  defp count_number([], _, solution), do: solution

  defp count_number([number | rest], number, solution),
    do: count_number(rest, number, solution + 1)

  defp count_number([_ | rest], number, solution), do: count_number(rest, number, solution)
end
