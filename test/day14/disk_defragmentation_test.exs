defmodule Day14.DiskDefragmentationTest do
  use ExUnit.Case, async: true
  alias Day14.DiskDefragmentation

  test "part1 - count squares" do
    assert DiskDefragmentation.part1("priv/day14/test.txt") == 8108
  end

  test "part2 - count groups" do
    assert DiskDefragmentation.part2("priv/day14/test.txt") == 1242
  end
end
