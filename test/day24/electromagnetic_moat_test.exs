defmodule Day24.ElectromagneticMoatTest do
  use ExUnit.Case, async: true
  alias Day24.ElectromagneticMoat

  test "part1 - strenght of strongest bridge" do
    input = """
    0/2
    2/2
    2/3
    3/4
    3/5
    0/1
    10/1
    9/10
    """

    assert ElectromagneticMoat.part1_with_input(input) == 31
  end

  test "part2 - longest bridge with max strength" do
    input = """
    0/2
    2/2
    2/3
    3/4
    3/5
    0/1
    10/1
    9/10
    """

    assert ElectromagneticMoat.part2_with_input(input) == 19
  end
end
