defmodule Aoc2024.Solutions.Y24.Day15 do
  alias AoC.Input

  @start if Mix.env() == :test, do: {4, 4}, else: {24, 24}
  @start_2 if Mix.env() == :test, do: {4, 8}, else: {24, 48}

  def parse(input, part) do
    [map, input] = input |> Input.read!() |> String.split("\n\n")
    {parse_map(map, part), parse_input(input)}
  end

  def part_one({map, input}) do
    input
    |> Enum.reduce({@start, map}, &move_robot(&2, &1))
    |> elem(1)
    |> Map.to_list()
    |> Enum.filter(fn {{_x, _y}, e} -> e == "O" end)
    |> Enum.reduce(0, fn {{x, y}, _}, acc ->
      acc + x * 100 + y
    end)
  end

  def part_two({map, input}) do
    input
    |> Enum.reduce({@start_2, map}, &move_robot(&2, &1))
    |> elem(1)
    |> Map.to_list()
    |> Enum.filter(fn {{_x, _y}, e} -> e == "[" end)
    |> Enum.reduce(0, fn {{x, y}, _}, acc ->
      acc + x * 100 + y
    end)
  end

  defp next_position({x, y}, symbol) do
    case symbol do
      ">" -> {x, y + 1}
      "<" -> {x, y - 1}
      "v" -> {x + 1, y}
      "^" -> {x - 1, y}
    end
  end

  defp move_robot({position, map}, symbol) do
    case check_boxes(position, symbol, map, []) do
      {:error, :unmovable} -> {position, map}
      {:ok, boxes} -> {next_position(position, symbol), update_map(map, boxes, symbol)}
    end
  end

  defp check_boxes(position, symbol, map, acc) do
    {x, y} = next_position = next_position(position, symbol)

    case Map.get(map, next_position) do
      nil -> {:ok, acc}
      "O" -> check_boxes(next_position, symbol, map, [next_position | acc])
      "[" -> check_pboxes({x, y}, {x, y + 1}, symbol, map, acc)
      "]" -> check_pboxes({x, y}, {x, y - 1}, symbol, map, acc)
      "#" -> {:error, :unmovable}
    end
  end

  defp check_pboxes(position, pposition, symbol, map, acc) when symbol in ["^", "v"] do
    with {:ok, acc_right} <- check_boxes(position, symbol, map, [position | acc]),
         {:ok, acc} <- check_boxes(pposition, symbol, map, [pposition | acc_right]) do
      {:ok, Enum.uniq(acc)}
    end
  end

  defp check_pboxes(position, _pposition, symbol, map, acc) do
    check_boxes(position, symbol, map, [position | acc])
  end

  defp update_map(map, boxes, symbol) do
    Enum.reduce(boxes, map, fn box_position, map ->
      {box, map} = Map.pop!(map, box_position)
      next_position = next_position(box_position, symbol)
      Map.put(map, next_position, box)
    end)
  end

  defp parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.reduce([], fn line, acc ->
      Enum.reduce(String.codepoints(line), acc, fn e, acc -> [e | acc] end)
    end)
    |> Enum.reverse()
  end

  defp parse_map(map, part) do
    map
    |> String.split("\n")
    |> Stream.with_index()
    |> Enum.reduce(%{}, fn {line, x}, acc ->
      line
      |> String.codepoints()
      |> maybe_expand(part)
      |> Stream.with_index()
      |> Enum.reduce(acc, fn
        {e, _y}, acc when e in [".", "@"] -> acc
        {e, y}, acc -> Map.put(acc, {x, y}, e)
      end)
    end)
  end

  defp maybe_expand(list, :part_one), do: list

  defp maybe_expand(list, :part_two) do
    list
    |> Enum.map(fn
      "#" -> ["#", "#"]
      "O" -> ["[", "]"]
      "." -> [".", "."]
      "@" -> ["@", "."]
    end)
    |> List.flatten()
  end
end
