defmodule Day03.SpiralMemoryTest do
  use ExUnit.Case, async: true
  alias Day03.SpiralMemory

  test "part1 - from square 1" do
    assert SpiralMemory.part1(1) == 0
  end

  test "part1 - from square 12" do
    assert SpiralMemory.part1(12) == 3
  end

  test "part1 - from square 23" do
    assert SpiralMemory.part1(23) == 2
  end

  test "part1 - from square 1024" do
    assert SpiralMemory.part1(1024) == 31
  end
end
