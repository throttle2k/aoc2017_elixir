defmodule Day06.MemoryReallocationTest do
  use ExUnit.Case, async: true
  alias Day06.MemoryReallocation

  test "part1 - redistribute 0 2 7 0" do
    input = %{0 => 0, 1 => 2, 2 => 7, 3 => 0}
    assert MemoryReallocation.redistribute(input) == %{0 => 2, 1 => 4, 2 => 1, 3 => 2}
  end

  test "part1 - redistribute 2 4 1 2" do
    input = %{0 => 2, 1 => 4, 2 => 1, 3 => 2}
    assert MemoryReallocation.redistribute(input) == %{0 => 3, 1 => 1, 2 => 2, 3 => 3}
  end

  test "part1 - redistribute 3 1 2 3" do
    input = %{0 => 3, 1 => 1, 2 => 2, 3 => 3}
    assert MemoryReallocation.redistribute(input) == %{0 => 0, 1 => 2, 2 => 3, 3 => 4}
  end

  test "part1 - redistribute 0 2 3 4" do
    input = %{0 => 0, 1 => 2, 2 => 3, 3 => 4}
    assert MemoryReallocation.redistribute(input) == %{0 => 1, 1 => 3, 2 => 4, 3 => 1}
  end

  test "part1 - redistribute 1 3 4 1" do
    input = %{0 => 1, 1 => 3, 2 => 4, 3 => 1}
    assert MemoryReallocation.redistribute(input) == %{0 => 2, 1 => 4, 2 => 1, 3 => 2}
  end

  test "part1 - count reallocations" do
    input = "0\t2\t7\t0"
    assert MemoryReallocation.part1(input) == 5
  end

  test "part 2 cycle length" do
    input = "0\t2\t7\t0"
    assert MemoryReallocation.part2(input) == 4
  end
end
