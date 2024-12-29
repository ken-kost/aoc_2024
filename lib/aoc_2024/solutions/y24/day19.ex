defmodule Aoc2024.Solutions.Y24.Day19 do
  alias AoC.Input

  def parse(input, part) do
    [part_1, part_2] = input |> Input.read!() |> String.split("\n\n")
    patterns = Enum.map(String.split(part_1, ","), &String.trim/1)
    [{:top, tree}] = preprocess_patterns(_groups = %{top: patterns})
    designs = String.split(String.trim(part_2), "\n")
    {tree, designs, _all? = if(part == :part_one, do: false, else: true)}
  end

  def part_one({tree, designs, all?}) do
    designs
    |> Enum.map(&(count(&1, tree, all?, _memo = %{"" => 1}) |> elem(0)))
    |> Enum.sum()
  end

  def part_two({tree, designs, all?}) do
    designs
    |> Enum.map(&(count(&1, tree, all?, _memo = %{"" => 1}) |> elem(0)))
    |> Enum.sum()
  end

  defp count(design, tree, all?, memo) do
    case memo do
      %{^design => ways} ->
        {ways, memo}

      _ ->
        match_one(design, tree, _position = 0)
        |> Enum.flat_map_reduce(memo, fn size, memo when is_integer(size) ->
          rest = :binary.part(design, size, byte_size(design) - size)

          case count(rest, tree, all?, memo) do
            {0, memo} -> {[], memo}
            {ways, memo} -> {[ways], memo}
          end
        end)
        |> then(fn {possible, memo} ->
          ways =
            cond do
              possible == [] -> 0
              all? -> Enum.sum(possible)
              true -> 1
            end

          memo = Map.put(memo, design, ways)
          {ways, memo}
        end)
    end
  end

  defp match_one(design, tree, position) do
    case design do
      <<first::binary-size(1), rest::binary>> ->
        case Enum.find_value(tree, fn
               {^first, rest_of_tree} -> rest_of_tree
               {_letter, _rest} -> nil
             end) do
          nil ->
            nil_match(tree, position)

          rest_of_tree ->
            nil_match(tree, position) ++ match_one(rest, rest_of_tree, position + 1)
        end

      <<>> ->
        nil_match(tree, position)
    end
  end

  defp nil_match(tree, position) do
    case tree do
      [{nil, _} | _] -> [position]
      _ -> []
    end
  end

  defp preprocess_patterns(groups) do
    Enum.map(groups, fn {key, group} ->
      group
      |> Enum.group_by(fn
        "" -> nil
        pattern -> :binary.part(pattern, 0, 1)
      end)
      |> Enum.map(fn {letter, patterns} ->
        {letter,
         Enum.map(patterns, fn
           "" -> ""
           pattern -> :binary.part(pattern, 1, byte_size(pattern) - 1)
         end)}
      end)
      |> then(fn group ->
        case group do
          nil: [""] -> {key, nil: []}
          group -> {key, preprocess_patterns(group)}
        end
      end)
    end)
  end
end
