defmodule Aoc2024.Solutions.Y24.Day05 do
  alias AoC.Input

  def parse(input, _part) do
    [rules, updates] = input |> Input.read!() |> String.split("\n\n")
    {parser(rules, "|"), parser(updates, ",")}
  end

  def part_one({rules, updates}) do
    updates
    |> Enum.map(&{&1, pair_up(&1)})
    |> Enum.filter(fn {_, list} -> check_rules(list, rules) end)
    |> Enum.map(fn {original, _} -> original end)
    |> Enum.reduce(0, &(Enum.at(&1, div(length(&1), 2)) + &2))
  end

  def part_two({rules, updates}) do
    updates
    |> Enum.map(&{&1, pair_up(&1)})
    |> Enum.filter(fn {_, list} -> not check_rules(list, rules) end)
    |> Enum.map(fn {e, list} -> switch_by_rules(list, rules, e) end)
    |> Enum.reduce(0, &(Enum.at(&1, div(length(&1), 2)) + &2))
  end

  defp check_rules([], _rules), do: true

  defp check_rules([{a, b} | rest], rules) do
    case Enum.find(rules, &(&1 == [a, b])) do
      nil -> false
      _ -> check_rules(rest, rules)
    end
  end

  defp switch_by_rules([], _rules, solution), do: solution

  defp switch_by_rules([{a, b} | rest], rules, solution) do
    case Enum.find(rules, &(&1 == [a, b])) do
      nil ->
        solution = switch_up(solution, a, b)
        switch_by_rules(pair_up(solution), rules, solution)

      _ ->
        switch_by_rules(rest, rules, solution)
    end
  end

  defp pair_up(list) do
    Enum.reduce(Enum.with_index(list), [], fn {_v, i}, acc ->
      {heads, rest} = Enum.split(list, i + 1)
      head = List.last(heads)
      Enum.map(rest, fn e -> {head, e} end) ++ acc
    end)
  end

  defp switch_up(list, a, b) do
    Enum.map(list, fn e ->
      cond do
        e == a -> b
        e == b -> a
        true -> e
      end
    end)
  end

  defp parser(input, separator) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn e ->
      Enum.map(String.split(e, separator), &String.to_integer(&1))
    end)
  end
end
