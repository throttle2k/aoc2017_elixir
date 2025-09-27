defmodule Day11.HexEdTest do
  use ExUnit.Case, async: true
  alias Day11.HexEd

  test "part1 - case 1" do
    input = "ne,ne,ne"
    assert HexEd.min_steps(input) == 3
  end

  test "part1 - case 2" do
    input = "ne,ne,sw,sw"
    assert HexEd.min_steps(input) == 0
  end

  test "part1 - case 3" do
    input = "ne,ne,s,s"
    assert HexEd.min_steps(input) == 2
  end

  test "part1 - case 4" do
    input = "se,sw,se,sw,sw"
    assert HexEd.min_steps(input) == 3
  end
end
