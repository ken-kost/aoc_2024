defmodule Aoc2024.Solutions.Y24.Day12 do
  alias AoC.Input

  def parse(input, _part) do
    [{first_line, 0} | rest] =
      input
      |> Input.stream!(trim: true)
      |> Enum.with_index()

    first_chunks =
      first_line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {e, y} -> {e, 0, y} end)
      |> Enum.chunk_by(fn {e, _, _} -> e end)

    Enum.reduce(rest, first_chunks, fn {line, x}, acc ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {e, y} -> {e, x, y} end)
      |> Enum.chunk_by(fn {e, _, _} -> e end)
      |> Enum.reduce(acc, fn chunk, groups ->
        group_chunk(groups, chunk)
      end)
    end)
  end

  def part_one(problem) do
    problem
    |> Enum.reduce(0, fn group, acc ->
      group = Enum.map(group, fn {_, x, y} -> {x, y} end)

      fence =
        Enum.reduce(group, 0, fn point, acc ->
          acc + length(calculate_fence(point, group))
        end)

      acc + length(group) * fence
    end)
  end

  def part_two(problem) do
    problem
    |> Enum.map(fn group ->
      group = Enum.map(group, fn {_, x, y} -> {x, y} end)

      Enum.reduce(group, [], fn point, acc ->
        [{point, calculate_fence(point, group)} | acc]
      end)
    end)
    |> Enum.map(fn group ->
      h_chunks = Enum.chunk_by(group, fn {{x, _y}, _} -> x end)
      counter_h = count_sides(h_chunks, :up, 1) + count_sides(h_chunks, :down, 1)
      v_chunks = Enum.group_by(group, fn {{_x, y}, _} -> y end) |> Map.values()
      counter_v = count_sides(v_chunks, :left, 0) + count_sides(v_chunks, :right, 0)
      {length(group), counter_h + counter_v}
    end)
    |> Enum.reduce(0, fn {length, sides}, acc -> acc + length * sides end)
  end

  defp group_chunk(groups, chunk) do
    case Enum.split_with(groups, fn group -> belongs_to?(group, chunk) end) do
      {[], groups} -> [chunk | groups]
      {chunk_groups, groups} -> [Enum.concat(chunk_groups ++ [chunk]) | groups]
    end
  end

  defp belongs_to?(group, chunk) do
    Enum.any?(group, fn {e, x, y} -> {e, x + 1, y} in chunk end)
  end

  defp calculate_fence({x, y}, list) do
    result = []
    result = if {x + 1, y} in list, do: result, else: [:down | result]
    result = if {x - 1, y} in list, do: result, else: [:up | result]
    result = if {x, y + 1} in list, do: result, else: [:right | result]
    if {x, y - 1} in list, do: result, else: [:left | result]
  end

  defp count_sides(chunks, direction, index) do
    Enum.reduce(chunks, 0, fn chunk, acc ->
      acc +
        case Enum.filter(chunk, fn {_point, fences} -> direction in fences end) do
          [] ->
            0

          [chunk_up_head | chunk_up_rest] ->
            {point, _} = chunk_up_head
            e = elem(point, index)

            {_, counter} =
              Enum.reduce(chunk_up_rest, {e, 1}, fn {point, _}, {tracker, counter} ->
                if elem(point, index) + 1 == tracker do
                  {tracker - 1, counter}
                else
                  {elem(point, index), counter + 1}
                end
              end)

            counter
        end
    end)
  end
end
