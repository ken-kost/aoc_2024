defmodule Aoc2024.Solutions.Y24.Day03 do
  alias AoC.Input

  def parse(input, _part) do
    input |> Input.read!() |> String.codepoints()
  end

  def part_one(problem) do
    find_muls(problem, 0)
  end

  def part_two(problem) do
    find_muls_and_dos(problem, 0, 1)
  end

  defp find_muls([], solution), do: solution

  defp find_muls(["m", "u", "l", "(", a1, ",", b1, ")" | rest], solution) do
    case {Integer.parse(a1), Integer.parse(b1)} do
      {{n1, _}, {n2, _}} -> find_muls(rest, solution + n1 * n2)
      _ -> find_muls(rest, solution)
    end
  end

  defp find_muls(["m", "u", "l", "(", a1, ",", b1, b2, ")" | rest], solution) do
    case {Integer.parse(a1), Integer.parse(b1 <> b2)} do
      {{n1, _}, {n2, _}} -> find_muls(rest, solution + n1 * n2)
      _ -> find_muls(rest, solution)
    end
  end

  defp find_muls(["m", "u", "l", "(", a1, a2, ",", b1, ")" | rest], solution) do
    case {Integer.parse(a1 <> a2), Integer.parse(b1)} do
      {{n1, _}, {n2, _}} -> find_muls(rest, solution + n1 * n2)
      _ -> find_muls(rest, solution)
    end
  end

  defp find_muls(["m", "u", "l", "(", a1, a2, ",", b1, b2, ")" | rest], solution) do
    case {Integer.parse(a1 <> a2), Integer.parse(b1 <> b2)} do
      {{n1, _}, {n2, _}} -> find_muls(rest, solution + n1 * n2)
      _ -> find_muls(rest, solution)
    end
  end

  defp find_muls(["m", "u", "l", "(", a1, ",", b1, b2, b3, ")" | rest], solution) do
    case {Integer.parse(a1), Integer.parse(b1 <> b2 <> b3)} do
      {{n1, _}, {n2, _}} -> find_muls(rest, solution + n1 * n2)
      _ -> find_muls(rest, solution)
    end
  end

  defp find_muls(["m", "u", "l", "(", a1, a2, a3, ",", b1, ")" | rest], solution) do
    case {Integer.parse(a1 <> a2 <> a3), Integer.parse(b1)} do
      {{n1, _}, {n2, _}} -> find_muls(rest, solution + n1 * n2)
      _ -> find_muls(rest, solution)
    end
  end

  defp find_muls(["m", "u", "l", "(", a1, a2, ",", b1, b2, b3, ")" | rest], solution) do
    case {Integer.parse(a1 <> a2), Integer.parse(b1 <> b2 <> b3)} do
      {{n1, _}, {n2, _}} -> find_muls(rest, solution + n1 * n2)
      _ -> find_muls(rest, solution)
    end
  end

  defp find_muls(["m", "u", "l", "(", a1, a2, a3, ",", b1, b2, ")" | rest], solution) do
    case {Integer.parse(a1 <> a2 <> a3), Integer.parse(b1 <> b2)} do
      {{n1, _}, {n2, _}} -> find_muls(rest, solution + n1 * n2)
      _ -> find_muls(rest, solution)
    end
  end

  defp find_muls(["m", "u", "l", "(", a1, a2, a3, ",", b1, b2, b3, ")" | rest], solution) do
    case {Integer.parse(a1 <> a2 <> a3), Integer.parse(b1 <> b2 <> b3)} do
      {{n1, _}, {n2, _}} -> find_muls(rest, solution + n1 * n2)
      _ -> find_muls(rest, solution)
    end
  end

  defp find_muls([_ | rest], solution), do: find_muls(rest, solution)

  defp find_muls_and_dos([], solution, _f), do: solution

  defp find_muls_and_dos(["m", "u", "l", "(", a1, ",", b1, ")" | rest], solution, f) do
    case {Integer.parse(a1), Integer.parse(b1)} do
      {{n1, _}, {n2, _}} -> find_muls_and_dos(rest, solution + (n1 * n2 * f), f)
      _ -> find_muls_and_dos(rest, solution, f)
    end
  end

  defp find_muls_and_dos(["m", "u", "l", "(", a1, ",", b1, b2, ")" | rest], solution, f) do
    case {Integer.parse(a1), Integer.parse(b1 <> b2)} do
      {{n1, _}, {n2, _}} -> find_muls_and_dos(rest, solution + (n1 * n2 * f), f)
      _ -> find_muls_and_dos(rest, solution, f)
    end
  end

  defp find_muls_and_dos(["m", "u", "l", "(", a1, a2, ",", b1, ")" | rest], solution, f) do
    case {Integer.parse(a1 <> a2), Integer.parse(b1)} do
      {{n1, _}, {n2, _}} -> find_muls_and_dos(rest, solution + (n1 * n2 * f), f)
      _ -> find_muls_and_dos(rest, solution, f)
    end
  end

  defp find_muls_and_dos(["m", "u", "l", "(", a1, a2, ",", b1, b2, ")" | rest], solution, f) do
    case {Integer.parse(a1 <> a2), Integer.parse(b1 <> b2)} do
      {{n1, _}, {n2, _}} -> find_muls_and_dos(rest, solution + (n1 * n2 * f), f)
      _ -> find_muls_and_dos(rest, solution, f)
    end
  end

  defp find_muls_and_dos(["m", "u", "l", "(", a1, ",", b1, b2, b3, ")" | rest], solution, f) do
    case {Integer.parse(a1), Integer.parse(b1 <> b2 <> b3)} do
      {{n1, _}, {n2, _}} -> find_muls_and_dos(rest, solution + (n1 * n2 * f), f)
      _ -> find_muls_and_dos(rest, solution, f)
    end
  end

  defp find_muls_and_dos(["m", "u", "l", "(", a1, a2, a3, ",", b1, ")" | rest], solution, f) do
    case {Integer.parse(a1 <> a2 <> a3), Integer.parse(b1)} do
      {{n1, _}, {n2, _}} -> find_muls_and_dos(rest, solution + (n1 * n2 * f), f)
      _ -> find_muls_and_dos(rest, solution, f)
    end
  end

  defp find_muls_and_dos(["m", "u", "l", "(", a1, a2, ",", b1, b2, b3, ")" | rest], solution, f) do
    case {Integer.parse(a1 <> a2), Integer.parse(b1 <> b2 <> b3)} do
      {{n1, _}, {n2, _}} -> find_muls_and_dos(rest, solution + (n1 * n2 * f), f)
      _ -> find_muls_and_dos(rest, solution, f)
    end
  end

  defp find_muls_and_dos(["m", "u", "l", "(", a1, a2, a3, ",", b1, b2, ")" | rest], solution, f) do
    case {Integer.parse(a1 <> a2 <> a3), Integer.parse(b1 <> b2)} do
      {{n1, _}, {n2, _}} -> find_muls_and_dos(rest, solution + (n1 * n2 * f), f)
      _ -> find_muls_and_dos(rest, solution, f)
    end
  end

  defp find_muls_and_dos(["m", "u", "l", "(", a1, a2, a3, ",", b1, b2, b3, ")" | rest], solution, f) do
    case {Integer.parse(a1 <> a2 <> a3), Integer.parse(b1 <> b2 <> b3)} do
      {{n1, _}, {n2, _}} -> find_muls_and_dos(rest, solution + (n1 * n2 * f), f)
      _ -> find_muls_and_dos(rest, solution, f)
    end
  end

  defp find_muls_and_dos(["d", "o", "(", ")" | rest], solution, _f), do: find_muls_and_dos(rest, solution, 1)

  defp find_muls_and_dos(["d", "o", "n", "'", "t", "(", ")" | rest], solution, _f), do: find_muls_and_dos(rest, solution, 0)

  defp find_muls_and_dos([_ | rest], solution, f), do: find_muls_and_dos(rest, solution, f)
end
