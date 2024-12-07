defmodule Aoc2024.Solutions.Y24.Day07 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(fn line ->
      [result, equation] = String.split(line, ":")
      equation_parts = equation |> String.trim() |> String.split(" ")
      {String.to_integer(result), Enum.map(equation_parts, &String.to_integer/1)}
    end)
  end

  def part_one(problem) do
    Enum.reduce(problem, 0, fn {result, parts}, acc ->
      if valid_equation?(parts, [:+, :*], result), do: result + acc, else: acc
    end)
  end

  def part_two(problem) do
    {solution, problem} =
      Enum.reduce(problem, {0, []}, fn {result, parts}, {solution, next_parts} ->
        if valid_equation?(parts, [:+, :*], result),
          do: {solution + result, next_parts},
          else: {solution, [{result, parts} | next_parts]}
      end)

    Enum.reduce(problem, solution, fn {result, parts}, acc ->
      if valid_equation?(parts, [:+, :*, :||], result), do: result + acc, else: acc
    end)
  end

  defp valid_equation?([part | rest_of_parts], operators, result) do
    length(rest_of_parts)
    |> generate_operator_combinations(operators)
    |> Enum.reduce_while(false, fn combination, acc ->
      if calculate_equation(combination, rest_of_parts, part) == result do
        {:halt, true}
      else
        {:cont, acc}
      end
    end)
  end

  defp generate_operator_combinations(length, operators) do
    Enum.reduce(1..length, [[]], fn _, acc ->
      for symbol <- operators,
          combination <- acc do
        [symbol | combination]
      end
    end)
  end

  defp calculate_equation(_, [], solution), do: solution

  defp calculate_equation([:+ | operators], [number | numbers], solution) do
    calculate_equation(operators, numbers, solution + number)
  end

  defp calculate_equation([:* | operators], [number | numbers], solution) do
    calculate_equation(operators, numbers, solution * number)
  end

  defp calculate_equation([:|| | operators], [number | numbers], solution) do
    calculate_equation(operators, numbers, String.to_integer("#{solution}" <> "#{number}"))
  end
end
