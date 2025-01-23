defmodule Aoc2024.Solutions.Y15.Day06Test do
  alias AoC.Input, warn: false
  alias Aoc2024.Solutions.Y15.Day06, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2015 --day 6
  #
  #     mix test test/2015/day06_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2015 --day 6 --part 1
  #
  # Use sample input file:
  #
  #     # returns {:ok, "priv/input/2015/day-06-mysuffix.inp"}
  #     {:ok, path} = Input.resolve(2015, 6, "mysuffix")
  #
  # Good luck!

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  test "part one example" do
    input = ~S"""
    turn on 0,0 through 999,999
    toggle 0,0 through 999,0
    turn off 499,499 through 500,500
    """

    assert 998_996 == solve(input, :part_one)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  # @part_one_solution CHANGE_ME
  #
  # test "part one solution" do
  #   assert {:ok, @part_one_solution} == AoC.run(2015, 6, :part_one)
  # end

  test "part two example" do
    input = ~S"""
    turn on 0,0 through 0,0
    toggle 0,0 through 999,999
    """

    assert 2_000_001 == solve(input, :part_two)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2015, 6, :part_two)
  # end
end
