defmodule Day17.SpinlockTest do
  use ExUnit.Case, async: true
  alias Day17.Spinlock

  test "part1 - value after 2017" do
    assert Spinlock.part1(3) == 638
  end
end
