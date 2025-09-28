defmodule Day12.DigitalPlumberTest do
  use ExUnit.Case, async: true
  alias Day12.DigitalPlumber

  test "part1 - programs in group containing 0" do
    input = """
    0 <-> 2
    1 <-> 1
    2 <-> 0, 3, 4
    3 <-> 2, 4
    4 <-> 2, 3, 6
    5 <-> 6
    6 <-> 4, 5
    """

    result =
      input
      |> DigitalPlumber.parse()
      |> DigitalPlumber.groups_containing(0)

    assert result == 6
  end

  test "part2 - count groups" do
    input = """
    0 <-> 2
    1 <-> 1
    2 <-> 0, 3, 4
    3 <-> 2, 4
    4 <-> 2, 3, 6
    5 <-> 6
    6 <-> 4, 5
    """

    result =
      input
      |> DigitalPlumber.parse()
      |> DigitalPlumber.count_groups()

    assert result == 2
  end
end
