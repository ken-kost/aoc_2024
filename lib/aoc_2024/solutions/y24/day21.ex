defmodule Aoc2024.Solutions.Y24.Day21 do
  alias AoC.Input

  alias Aoc2024.Solutions.Y24.Day21.Keypad

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(fn code ->
      {number, _} = Integer.parse(code)
      {number, code}
    end)
  end

  def part_one(problem) do
    pads = [Keypad.numeric(), Keypad.direct(), Keypad.direct()]

    problem
    |> Enum.map(fn {number, code} ->
      code
      |> String.to_charlist()
      |> press(pads)
      |> then(fn count -> number * count end)
    end)
    |> Enum.sum()
  end

  defp press(buttons, pads) do
    {result, _} =
      Enum.map_reduce(buttons, pads, fn button, pads ->
        case pads do
          [] ->
            {count([button]), []}

          [pad | pads] ->
            cache_key = {button, pad.position, length(pads)}

            case Process.get(cache_key) do
              nil ->
                nil
            end
        end
      end)
  end

  # def part_two(problem) do
  #   problem
  # end
end

defmodule Aoc2024.Solutions.Y24.Day21.Keypad do
  defstruct map: %{}, parser: nil, position: {0, 0}

  @numeric_map """
  789
  456
  123
  .0A
  """

  @direct_map """
  .^A
  <v>
  """

  def numeric(), do: init(@numeric_map, &numeric_parser/1)
  def direct(), do: init(@direct_map, &direct_parser/1)

  def init(map, parser) do
    map = parse_map(map, parser)
    position = locate_activate_position(map)
    %__MODULE__{map: map, parser: parser, position: position}
  end

  defp parse_map(map, parser) do
    map
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, x} ->
      line
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.map(fn {char, y} -> {{x, y}, parser.(char)} end)
    end)
    |> Map.new()
  end

  defp locate_activate_position(map) do
    map
    |> Enum.find(fn {_, button} -> button == :activate end)
    |> elem(0)
  end

  defp numeric_parser(char) do
    case char do
      _ when char in ?0..?9 -> char - ?0
      ?A -> :activate
      ?. -> :panic
    end
  end

  defp direct_parser(char) do
    case char do
      ?^ -> {-1, 0}
      ?< -> {0, -1}
      ?> -> {0, 1}
      ?v -> {1, 0}
      ?. -> :panic
      ?A -> :activate
    end
  end
end
