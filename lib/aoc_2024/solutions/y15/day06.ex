defmodule Aoc2024.Solutions.Y15.Day06 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(&parse_line/1)
  end

  def part_one(problem) do
    light_up(problem, MapSet.new())
  end

  def part_two(problem) do
    bright_up(problem, %{})
  end

  defp light_up([], acc), do: MapSet.size(acc)

  defp light_up([{key, {x1, y1}, {x2, y2}} | rest], acc) do
    points = Enum.flat_map(x1..x2, &Enum.map(y1..y2, fn y -> {&1, y} end))

    acc =
      case key do
        :on ->
          Enum.reduce(points, acc, &MapSet.put(&2, &1))

        :off ->
          Enum.reduce(points, acc, &MapSet.delete(&2, &1))

        :toggle ->
          Enum.reduce(points, acc, fn point, acc ->
            if MapSet.member?(acc, point) do
              MapSet.delete(acc, point)
            else
              MapSet.put(acc, point)
            end
          end)
      end

    light_up(rest, acc)
  end

  defp bright_up([], acc), do: acc |> Map.values() |> Enum.sum()

  defp bright_up([{key, {x1, y1}, {x2, y2}} | rest], acc) do
    points = Enum.flat_map(x1..x2, &Enum.map(y1..y2, fn y -> {&1, y} end))

    acc =
      case key do
        :on ->
          Enum.reduce(points, acc, &Map.update(&2, &1, 1, fn c -> c + 1 end))

        :off ->
          Enum.reduce(points, acc, &Map.update(&2, &1, 0, fn c -> max(0, c - 1) end))

        :toggle ->
          Enum.reduce(points, acc, &Map.update(&2, &1, 2, fn c -> c + 2 end))
      end

    bright_up(rest, acc)
  end

  defp parse_line(line) do
    regex = ~r/^(turn (on|off)|toggle)\s+(\d+),(\d+)\s+through\s+(\d+),(\d+)/
    [_, action, _ | numbers] = Regex.run(regex, line)
    key = action |> String.split(" ") |> List.last() |> String.to_atom()
    [x1, y1, x2, y2] = Enum.map(numbers, &String.to_integer/1)
    {key, {x1, y1}, {x2, y2}}
  end
end
