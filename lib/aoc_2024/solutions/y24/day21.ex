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
    pads = [numeric(), direct(), direct()]

    problem
    |> Enum.map(fn {number, code} ->
      code
      |> String.to_charlist()
      |> press(pads)
      |> then(fn count -> number * count end)
    end)
    |> Enum.sum()
  end

  def part_two(problem) do
    pads = [numeric() | List.duplicate(direct(), 25)]

    problem
    |> Enum.map(fn {number, code} ->
      code
      |> String.to_charlist()
      |> press(pads)
      |> then(fn count -> number * count end)
    end)
    |> Enum.sum()
  end

  defp numeric() do
    parse = fn char ->
      case char do
        _ when char in ?0..?9 -> char - ?0
        ?A -> :activate
        ?. -> :panic
      end
    end

    """
    789
    456
    123
    .0A
    """
    |> Keypad.init(parse)
  end

  defp direct() do
    parse = &vector_dir/1

    """
    .^A
    <v>
    """
    |> Keypad.init(parse)
  end

  defp vector_dir(char) do
    case char do
      ?^ -> {-1, 0}
      ?< -> {0, -1}
      ?> -> {0, 1}
      ?v -> {1, 0}
      ?. -> :panic
      ?A -> :activate
    end
  end

  defp press(buttons, pads) do
    buttons |> press_recursive(pads) |> elem(0) |> count(0) |> elem(0)
  end

  defp press_recursive(buttons, pads) do
    Enum.map_reduce(buttons, pads, fn button, pads ->
      case pads do
        [] ->
          {count([button], _counter = 0), []}

        [pad | pads] ->
          cache_key = {button, pad.position, length(pads)}

          case Process.get(cache_key) do
            nil ->
              case button do
                {:alt, [alt | alts]} ->
                  {first, [pad | pads]} = press_recursive(alt, [pad | pads])

                  rest =
                    Enum.map(alts, fn alt ->
                      {buttons, _} = press_recursive(alt, [pad | pads])
                      buttons
                    end)

                  {count({:alt, [first | rest]}, 0), [pad | pads]}

                _ when is_integer(button) ->
                  {buttons, pad} = Keypad.press(pad, button)
                  {buttons, pads} = press_recursive(buttons, pads)
                  {count(buttons, 0), [pad | pads]}
              end
              |> then(fn {value, [pad | _rest] = pads} ->
                Process.put(cache_key, {value, pad})
                {value, pads}
              end)

            {value, pad} ->
              {value, [pad | pads]}
          end
      end
    end)
  end

  # Characters counts are enclosed in a tuple to
  # distinguish them from counting characters

  @spec count(integer() | {integer()} | [integer()] | {:alt, [integer()]}, integer()) ::
          {integer()}
  defp count(char, counter) when is_integer(char), do: {counter + 1}
  defp count({number}, counter), do: {number + counter}
  defp count([number | rest], counter), do: count(rest, counter + elem(count(number, 0), 0))
  defp count({:alt, alternatives}, counter), do: {counter + count_alternatives(alternatives)}
  defp count([], counter), do: {counter}

  defp count_alternatives(alternatives),
    do: alternatives |> Enum.map(&count(&1, 0)) |> Enum.min() |> elem(0)
end

defmodule Aoc2024.Solutions.Y24.Day21.Keypad do
  defstruct position: {0, 0}, grid: %{}, parse: nil

  def init(grid, parse_char) do
    grid =
      grid
      |> String.split("\n", trim: true)
      |> parse_grid(parse_char)

    {position, _} =
      Enum.find(grid, fn {_, button} ->
        button === :activate
      end)

    %__MODULE__{position: position, grid: grid, parse: parse_char}
  end

  def press(pad, button) do
    button = pad.parse.(button)
    {to, _} = Enum.find(pad.grid, fn {_, b} -> b === button end)
    diff = sub(pad.position, to)
    moves = do_press(diff, to, pad.grid)

    moves =
      Enum.map(moves, fn move ->
        Enum.map(move, &symbolic_dir/1) ++ [?A]
      end)

    moves =
      case moves do
        [move] -> move
        _ -> [{:alt, moves}]
      end

    pad = %{pad | position: to}

    {moves, pad}
  end

  defp do_press({0, 0}, _to, _grid), do: [[]]

  defp do_press(diff, to, grid) do
    [{-1, 0}, {0, -1}, {0, 1}, {1, 0}]
    |> Enum.filter(fn dir ->
      new_diff = add(diff, dir)
      new_pos = add(to, new_diff)

      Map.has_key?(grid, new_pos) and
        distance(new_diff) < distance(diff) and
        Map.fetch!(grid, add(to, new_diff)) !== :panic
    end)
    |> Enum.flat_map(fn dir ->
      new_diff = add(diff, dir)

      do_press(new_diff, to, grid)
      |> Enum.map(fn path ->
        [dir | path]
      end)
    end)
  end

  defp distance({a, b}), do: abs(a) + abs(b)

  defp symbolic_dir(dir) do
    case dir do
      {-1, 0} -> ?^
      {1, 0} -> ?v
      {0, -1} -> ?<
      {0, 1} -> ?>
    end
  end

  defp add({a, b}, {c, d}), do: {a + c, b + d}

  defp sub({a, b}, {c, d}), do: {a - c, b - d}

  defp parse_grid(grid, parse_char) do
    grid
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, row} ->
      String.to_charlist(line)
      |> Enum.with_index()
      |> Enum.map(fn {char, col} ->
        position = {row, col}
        {position, parse_char.(char)}
      end)
    end)
    |> Map.new()
  end
end
