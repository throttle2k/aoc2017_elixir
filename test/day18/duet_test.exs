defmodule Day18.DuetTest do
  use ExUnit.Case, async: true
  alias Day18.Duet

  test "part1 - value of recovered frequency" do
    input = """
    set a 1
    add a 2
    mul a a
    mod a 5
    snd a
    set a 0
    rcv a
    jgz a -1
    set a 1
    jgz a -2
    """

    assert Duet.Part1.run_with_input(input) == 4
  end
end
