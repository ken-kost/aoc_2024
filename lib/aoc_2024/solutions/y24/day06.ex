defmodule Aoc2024.Solutions.Y24.Day06 do
  alias AoC.Input

  def parse(input, _part) do
    stream = Input.stream!(input, trim: true)

    {start, obstacles} =
      stream
      |> Stream.with_index()
      |> Enum.reduce({nil, MapSet.new()}, fn {line, x}, {start, obstacles} ->
        line
        |> String.to_charlist()
        |> Stream.with_index()
        |> Enum.reduce({start, obstacles}, fn
          {?#, y}, {start, obstacles} -> {start, MapSet.put(obstacles, {x, y})}
          {?^, y}, {_start, obstacles} -> {{x, y}, obstacles}
          _, {start, obstacles} -> {start, obstacles}
        end)
      end)

    row_end = Enum.count(stream) - 1
    col_end = length(String.to_charlist(Enum.at(stream, 0))) - 1

    {start, obstacles, row_end, col_end}
  end

  def part_one({{x, y}, obstacles, row_end, col_end}) do
    path = build_path({?^, {x - 1, y}}, obstacles, MapSet.new([{x, y}]), row_end, col_end)
    Enum.count(path)
  end

  def part_two({{x, y}, obstacles, row_end, col_end}) do
    path = build_path({?^, {x - 1, y}}, obstacles, MapSet.new([{x, y}]), row_end, col_end)

    Enum.reduce(path, 0, fn new_obstacle, counter ->
      obstacles = MapSet.put(obstacles, new_obstacle)
      limit = round(row_end * col_end / 2)
      v = check_path({?^, {x - 1, y}}, obstacles, row_end, col_end, 0, limit)
      v + counter
    end)
  end

  defp build_path({direction, {x, y}}, obstacles, solution, row_end, col_end) do
    cond do
      x < 0 or x > row_end or y < 0 or y > col_end ->
        solution

      MapSet.member?(obstacles, {x, y}) ->
        position = direct(direction, {x, y})
        build_path(position, obstacles, solution, row_end, col_end)

      true ->
        position = continue(direction, {x, y})
        build_path(position, obstacles, MapSet.put(solution, {x, y}), row_end, col_end)
    end
  end

  defp check_path({direction, {x, y}}, obstacles, row_end, col_end, counter, limit) do
    cond do
      counter == limit ->
        1

      x < 0 or x > row_end or y < 0 or y > col_end ->
        0

      MapSet.member?(obstacles, {x, y}) ->
        position = direct(direction, {x, y})
        check_path(position, obstacles, row_end, col_end, counter, limit)

      true ->
        position = continue(direction, {x, y})
        check_path(position, obstacles, row_end, col_end, counter + 1, limit)
    end
  end

  defp direct(c, {x, y}) do
    case c do
      ?^ -> {?>, {x + 1, y + 1}}
      ?> -> {?v, {x + 1, y - 1}}
      ?v -> {?<, {x - 1, y - 1}}
      ?< -> {?^, {x - 1, y + 1}}
    end
  end

  defp continue(c, {x, y}) do
    case c do
      ?^ -> {c, {x - 1, y}}
      ?> -> {c, {x, y + 1}}
      ?v -> {c, {x + 1, y}}
      ?< -> {c, {x, y - 1}}
    end
  end
end
