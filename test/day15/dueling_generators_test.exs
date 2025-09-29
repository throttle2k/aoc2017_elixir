defmodule Day15.DuelingGeneratorsTest do
  use ExUnit.Case, async: true
  alias Day15.DuelingGenerators

  @input %{a_start: 65, b_start: 8921}

  @tag :slow
  test "part1 - judge final count" do
    assert DuelingGenerators.part1(@input) == 588
  end

  @tag :slow
  test "part2 - judge final count with generator validation" do
    assert DuelingGenerators.part2(@input) == 309
  end
end
