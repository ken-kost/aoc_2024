defmodule Aoc2024.Solutions.Y24.Day17 do
  alias AoC.Input

  import Bitwise

  def parse(input, _part) do
    [registers, program] = String.split(Input.read!(input), "\n\n")
    [a, b, c] = registers |> String.split("\n") |> Enum.flat_map(&extract_numbers/1)
    {extract_numbers(program), %{a: a, b: b, c: c}}
  end

  def part_one({program, registers}) do
    program |> execute(registers, 0, []) |> Enum.join(",")
  end

  def part_two({expected, registers}) do
    solve(expected, registers, expected)
  end

  defp execute(program, registers, counter, output) do
    {opcode, literal} = {Enum.at(program, counter), Enum.at(program, counter + 1)}

    if is_nil(opcode) or is_nil(literal) do
      Enum.reverse(output)
    else
      operation = Map.get(opcodes(), opcode)
      combo = Map.get(combo_operands(), literal)
      result = operation.(combo.(registers), registers, literal, counter, output)
      {output, registers, counter} = result
      execute(program, registers, counter, output)
    end
  end

  defp solve(program, registers, expected) do
    # Looking at the program it can be seen that each output value
    # depends on the lower 10 bits of the value of register A.

    # Generate all possible A register values hat produce the first digit
    initial =
      Enum.map(0..1023, fn e ->
        {e, execute(program, Map.put(registers, :a, e), 0, [])}
      end)

    # Keep discarding the digits that don't match.
    # For each of the surviving elements extend the A register and
    # generate the next digit
    Enum.reduce(expected, {initial, 10}, fn digit, {as, shift} ->
      Enum.flat_map(as, fn {a, d} ->
        if hd(d) == digit do
          Enum.flat_map(0..7, fn value ->
            a_acc = value <<< shift ||| a
            registers = Map.put(registers, :a, a_acc >>> (shift - 7))
            output = execute(program, registers, 0, [])
            [{a_acc, output}]
          end)
        else
          []
        end
      end)
      |> then(&{&1, shift + 3})
    end)
    |> elem(0)
    |> Enum.min()
    |> elem(0)
  end

  defp combo_operands do
    %{
      0 => fn _ -> 0 end,
      1 => fn _ -> 1 end,
      2 => fn _ -> 2 end,
      3 => fn _ -> 3 end,
      4 => fn map -> Map.get(map, :a) end,
      5 => fn map -> Map.get(map, :b) end,
      6 => fn map -> Map.get(map, :c) end,
      7 => fn _map -> nil end
    }
  end

  defp opcodes do
    %{
      0 => fn
        combo, registers, _literal, counter, output ->
          registers = Map.update!(registers, :a, fn a -> trunc(a / :math.pow(2, combo)) end)
          {output, registers, counter + 2}
      end,
      1 => fn
        _combo, registers, literal, counter, output ->
          registers = Map.update!(registers, :b, fn b -> bxor(b, literal) end)
          {output, registers, counter + 2}
      end,
      2 => fn
        combo, registers, _literal, counter, output ->
          registers = Map.update!(registers, :b, fn _b -> rem(combo, 8) end)
          {output, registers, counter + 2}
      end,
      3 => fn
        _combo, registers, literal, counter, output ->
          case Map.get(registers, :a) do
            0 -> {output, registers, counter + 2}
            _a -> {output, registers, literal}
          end
      end,
      4 => fn
        _combo, registers, _literal, counter, output ->
          b = Map.get(registers, :b)
          c = Map.get(registers, :c)
          registers = Map.update!(registers, :b, fn _b -> bxor(b, c) end)
          {output, registers, counter + 2}
      end,
      5 => fn
        combo, registers, _literal, counter, output ->
          {[rem(combo, 8) | output], registers, counter + 2}
      end,
      6 => fn
        combo, registers, _literal, counter, output ->
          a = Map.get(registers, :a)
          registers = Map.update!(registers, :b, fn _b -> div(a, round(:math.pow(2, combo))) end)
          {output, registers, counter + 2}
      end,
      7 => fn
        combo, registers, _literal, counter, output ->
          a = Map.get(registers, :a)
          registers = Map.update!(registers, :c, fn _c -> div(a, round(:math.pow(2, combo))) end)
          {output, registers, counter + 2}
      end
    }
  end

  defp extract_numbers(string, regex \\ ~r/\d+(\.\d+)?/) do
    Enum.flat_map(Regex.scan(regex, string), &Enum.map(&1, fn e -> String.to_integer(e) end))
  end
end
