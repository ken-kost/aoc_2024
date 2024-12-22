defmodule Aoc2024.Solutions.Y24.Day16 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Stream.with_index()
    |> Enum.reduce({{}, {}, %{}}, fn {line, x}, acc ->
      line
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn
        {?S, y}, {_start, finish, map} -> {{x, y}, finish, Map.put(map, {x, y}, ?.)}
        {?E, y}, {start, _finish, map} -> {start, {x, y}, Map.put(map, {x, y}, ?E)}
        {e, y}, {start, finish, map} -> {start, finish, Map.put(map, {x, y}, e)}
      end)
    end)
  end

  def part_one({start, finish, map}) do
    element = {_score = 0, _position = start, _direction = {0, 1}, _passed = MapSet.new()}
    set = :gb_sets.singleton(element)
    find_paths(set, map, finish, _visited = MapSet.new(), _max_score = nil)
  end

  def part_two({start, finish, map}) do
    element = {_score = 0, _position = start, _direction = {0, 1}, _passed = MapSet.new()}
    set = :gb_sets.singleton(element)

    find_paths(set, map, finish, _visited = MapSet.new(), _max_score = :infinity)
    |> Enum.reduce(MapSet.new(), fn set, acc -> MapSet.union(acc, set) end)
    |> MapSet.size()
  end

  defp find_paths(set, map, finish, visited, max_score) do
    case if not :gb_sets.is_empty(set), do: :gb_sets.take_smallest(set) do
      nil ->
        []

      # part 1 case
      {{score, ^finish, _direction, _passed}, _set} when is_nil(max_score) ->
        score

      # part 2 case
      {{score, ^finish, _direction, passed}, set} ->
        if score <= max_score do
          max_score = min(max_score, score)
          [MapSet.put(passed, finish) | find_paths(set, map, finish, visited, max_score)]
        else
          []
        end

      {{score, position, direction, passed}, set} ->
        visited = MapSet.put(visited, {position, direction})
        passed = if is_nil(max_score), do: MapSet.new(), else: MapSet.put(passed, position)
        forward_path = forward_path(map, finish, score, position, direction, passed)
        rotated_paths = rotated_paths(map, score, position, direction, passed)
        paths = [forward_path | rotated_paths]
        set = update_set(paths, set, map, visited)
        find_paths(set, map, finish, visited, max_score)
    end
  end

  defp forward_path(map, finish, score, {x, y} = _position, {xd, yd} = direction, passed) do
    {xn, yn} = next_position = {x + xd, y + yd}
    next_left_position = {xn - yd, yn + xd}
    next_right_position = {xn + yd, yn - xd}

    if next_position != finish and
         Map.get(map, next_position) != ?# and
         Map.get(map, next_left_position) == ?# and
         Map.get(map, next_right_position) == ?# do
      passed = MapSet.put(passed, next_position)
      forward_path(map, finish, score + 1, next_position, direction, passed)
    else
      {score + 1, next_position, direction, passed}
    end
  end

  defp rotated_paths(map, score, {x, y} = position, {xd, yd} = _direction, passed) do
    left_position = {x - yd, y + xd}
    left_path = {score + 1000, position, {-yd, xd}, passed}
    right_position = {x + yd, y - xd}
    right_path = {score + 1000, position, {yd, -xd}, passed}
    paths = if Map.get(map, left_position) != ?#, do: [left_path], else: []
    if Map.get(map, right_position) != ?#, do: [right_path | paths], else: paths
  end

  defp update_set(paths, set, map, visited) do
    Enum.reduce(paths, set, fn {_score, position, direction, _passed} = element, set ->
      cond do
        Map.get(map, position) == ?# -> set
        MapSet.member?(visited, {position, direction}) -> set
        true -> :gb_sets.add(element, set)
      end
    end)
  end
end
