defmodule Aoc2024.Solutions.Y24.Day01 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!()
    |> Enum.reduce({[], []}, fn line, acc ->
      {acc1, acc2} = acc
      {num1, num2} = parse_line(line)
      {[num1 | acc1], [num2 | acc2]}
    end)
  end

  def part_one({list1, list2}) do
    Enum.sort(list1)
    |> Stream.zip(Enum.sort(list2))
    |> Enum.reduce(0, fn {num1, num2}, acc -> abs(num1 - num2) + acc end)
  end

  def part_two({list1, list2}) do
    list2 = Enum.sort(list2)

    list1
    |> Enum.sort()
    |> Enum.reduce(0, fn num, acc -> count_number(list2, num) * num + acc end)
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

  defp count_number(list, num) do
    Enum.reduce_while(list, 0, fn e, acc ->
      cond do
        e < num -> {:cont, acc}
        e == num -> {:cont, acc + 1}
        true -> {:halt, acc}
      end
    end)
  end
end
