defmodule Day25.TheHaltingProblemTest do
  use ExUnit.Case, async: true
  alias Day25.TheHaltingProblem

  test "part1 - diagnostic checksum" do
    transitions = %{
      {:a, 0} => {1, :right, :b},
      {:a, 1} => {0, :left, :b},
      {:b, 0} => {1, :left, :a},
      {:b, 1} => {1, :right, :a}
    }

    assert TheHaltingProblem.part1(transitions, 6) == 3
  end
end
