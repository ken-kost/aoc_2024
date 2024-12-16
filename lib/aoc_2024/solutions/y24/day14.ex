defmodule Aoc2024.Solutions.Y24.Day14 do
  alias AoC.Input

  @x_max if Mix.env() == :test, do: 11, else: 101
  @y_max if Mix.env() == :test, do: 7, else: 103

  @tree [{50, 51}, {49, 51}, {51, 51}, {48, 52}, {49, 52}, {50, 52}, {51, 52}, {52, 52}]

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(fn line ->
      ~r/-?\d+(\.\d+)?/
      |> Regex.scan(line)
      |> Enum.reduce({}, fn [e], acc ->
        Tuple.append(acc, String.to_integer(e))
      end)
    end)
  end

  def part_one(problem) do
    {q1, q2, q3, q4} =
      problem
      |> Enum.map(&move_robot(&1, 100))
      |> Enum.filter(fn {x, y, _xv, _yv} -> x != div(@x_max, 2) and y != div(@y_max, 2) end)
      |> Enum.reduce({0, 0, 0, 0}, fn {x, y, _xv, _yv}, {q1, q2, q3, q4} ->
        cond do
          x < div(@x_max, 2) and y < div(@y_max, 2) ->
            {q1 + 1, q2, q3, q4}

          x < div(@x_max, 2) and y > div(@y_max, 2) ->
            {q1, q2 + 1, q3, q4}

          x > div(@x_max, 2) and y < div(@y_max, 2) ->
            {q1, q2, q3 + 1, q4}

          x > div(@x_max, 2) and y > div(@y_max, 2) ->
            {q1, q2, q3, q4 + 1}
        end
      end)

    q1 * q2 * q3 * q4
  end

  def part_two(problem) do
    iterate_until(problem, 0)
  end

  defp iterate_until(robot_positions, solution) do
    robot_positions = Enum.map(robot_positions, &move_robot(&1, 1))
    positions = Enum.map(robot_positions, fn {x, y, _xv, _yv} -> {x, y} end)

    if Enum.all?(@tree, &(&1 in positions)),
      do: solution + 1,
      else: iterate_until(robot_positions, solution + 1)
  end

  defp move_robot(solution, 0), do: solution

  defp move_robot({x, y, xv, yv}, seconds) do
    x = rem(x + xv, @x_max)
    x = if x < 0, do: @x_max + x, else: x
    y = rem(y + yv, @y_max)
    y = if y < 0, do: @y_max + y, else: y
    move_robot({x, y, xv, yv}, seconds - 1)
  end
end
