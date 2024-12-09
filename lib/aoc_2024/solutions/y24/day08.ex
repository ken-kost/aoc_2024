defmodule Aoc2024.Solutions.Y24.Day08 do
  alias AoC.Input

  def parse(input, _part) do
    stream = Input.stream!(input, trim: true)

    antennas =
      stream
      |> Stream.with_index()
      |> Enum.reduce(%{}, fn {line, x}, antennas ->
        line
        |> String.to_charlist()
        |> Stream.with_index()
        |> Enum.reduce(antennas, fn
          {?., _}, antennas -> antennas
          {symbol, y}, antennas -> Map.update(antennas, symbol, [{x, y}], &[{x, y} | &1])
        end)
      end)
      |> Map.values()

    row_end = Enum.count(stream) - 1
    col_end = length(String.to_charlist(Enum.at(stream, 0))) - 1

    {antennas, row_end, col_end}
  end

  def part_one({antennas, row_end, col_end}) do
    antennas
    |> generate_combinations()
    |> Enum.reduce(MapSet.new(), fn combinations, antinodes ->
      Enum.reduce(combinations, antinodes, fn {{x1, y1}, {x2, y2}}, antinodes ->
        antinodes
        |> add_antinodes(x1, y1, x2 - x1, y2 - y1, row_end, col_end)
        |> add_antinodes(x2, y2, x1 - x2, y1 - y2, row_end, col_end)
      end)
    end)
    |> Enum.count()
  end

  def part_two({antennas, row_end, col_end}) do
    antennas
    |> generate_combinations()
    |> Enum.reduce(MapSet.new(List.flatten(antennas)), fn combinations, antinodes ->
      Enum.reduce(combinations, antinodes, fn {{x1, y1}, {x2, y2}}, antinodes ->
        antinodes
        |> add_antinodes_recursive(x1, y1, x2 - x1, y2 - y1, row_end, col_end)
        |> add_antinodes_recursive(x2, y2, x1 - x2, y1 - y2, row_end, col_end)
      end)
    end)
    |> Enum.count()
  end

  defp generate_combinations(antennas) do
    for antenna <- antennas do
      for {a, x} <- Enum.with_index(antenna),
          {b, y} <- Enum.with_index(antenna),
          x < y,
          do: {a, b}
    end
  end

  defp add_antinodes(antinodes, x_original, y_original, dx, dy, row_end, col_end) do
    {x, y} = {x_original - dx, y_original - dy}

    if x >= 0 and x <= row_end and y >= 0 and y <= col_end do
      MapSet.put(antinodes, {x, y})
    else
      antinodes
    end
  end

  defp add_antinodes_recursive(antinodes, x_original, y_original, dx, dy, row_end, col_end) do
    {x, y} = {x_original - dx, y_original - dy}

    if x >= 0 and x <= row_end and y >= 0 and y <= col_end do
      antinodes = MapSet.put(antinodes, {x, y})
      add_antinodes_recursive(antinodes, x, y, dx, dy, row_end, col_end)
    else
      antinodes
    end
  end
end
