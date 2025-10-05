defmodule Day22.SporificaVirusTest do
  use ExUnit.Case, async: true
  alias Day22.SporificaVirus.{Part1, Part2}

  test "part1 - count infections after 10000 bursts" do
    input = """
    ..#
    #..
    ...
    """

    assert Part1.part1_with_input(input) == 5587
  end

  @tag :slow
  test "part2 - count infections with weakening after 10000000 bursts" do
    input = """
    ..#
    #..
    ...
    """

    assert Part2.part2_with_input(input) == 2_511_944
  end
end
