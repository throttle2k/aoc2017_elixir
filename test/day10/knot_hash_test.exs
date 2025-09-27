defmodule Day10.KnotHashTest do
  use ExUnit.Case, async: true
  alias Day10.KnotHash

  test "part1 - multiply first two numbers" do
    list = [0, 1, 2, 3, 4]
    input = "3,4,1,5"

    assert KnotHash.part1(input, list) == 12
  end

  test "part2 - hash of empty string" do
    input = ""

    assert KnotHash.part2(input) == "a2582a3a0e66e6e86e3812dcb672a272"
  end

  test "part2 - hash of AoC 2017" do
    input = "AoC 2017"

    assert KnotHash.part2(input) == "33efeb34ea91902bb2f59c9920caa6cd"
  end

  test "part2 - hash of 1,2,3" do
    input = "1,2,3"

    assert KnotHash.part2(input) == "3efbe78a8d82f29979031a4aa0b16a9d"
  end

  test "part2 - hash of 1,2,4" do
    input = "1,2,4"

    assert KnotHash.part2(input) == "63960835bcdc130f0b66d7ff4f6a5a8e"
  end
end
