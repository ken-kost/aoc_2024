defmodule Aoc2024.Solutions.Y15.Day03 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.read!()
    |> String.trim()
    |> String.to_charlist()
  end

  def part_one(problem) do
    position = {0, 0}
    visited = MapSet.new([position])
    count_presents(problem, position, visited, _acc = 1) |> elem(1)
  end

  def part_two(problem) do
    {problem_1, problem_2} = split(problem, [], [], 0)
    position = {0, 0}
    visited = MapSet.new([position])
    {visited, solution_1} = count_presents(problem_1, position, visited, _acc = 1)
    {_visited, solution_2} = count_presents(problem_2, position, visited, _acc = 0)
    solution_1 + solution_2
  end

  defp count_presents([] = _locations, _position, visited, acc), do: {visited, acc}

  defp count_presents([head | rest], position, visited, acc) do
    position = move(position, head)
    acc = if position in visited, do: acc, else: acc + 1
    visited = MapSet.put(visited, position)
    count_presents(rest, position, visited, acc)
  end

  defp move({x, y}, 94), do: {x + 1, y}
  defp move({x, y}, 62), do: {x, y + 1}
  defp move({x, y}, 118), do: {x - 1, y}
  defp move({x, y}, 60), do: {x, y - 1}

  defp split([], acc_1, acc_2, _index), do: {Enum.reverse(acc_1), Enum.reverse(acc_2)}

  defp split([head | rest], acc_1, acc_2, index) do
    cond do
      rem(index, 2) == 0 -> split(rest, [head | acc_1], acc_2, index + 1)
      true -> split(rest, acc_1, [head | acc_2], index + 1)
    end
  end
end
