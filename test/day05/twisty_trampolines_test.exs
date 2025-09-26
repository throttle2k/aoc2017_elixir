defmodule Day05.TwistyTrampolinesTest do
  use ExUnit.Case, async: true
  alias Day05.TwistyTrampolines

  test "part 1 - exit in 5 moves" do
    assert TwistyTrampolines.jump("""
           0
           3
           0
           1
           -3
           """) == 5
  end

  test "part 2 - exit in 10 moves" do
    input = """
    0
    3
    0
    1
    -3
    """

    assert TwistyTrampolines.jump(input, fn prev_val ->
             cond do
               prev_val >= 3 -> prev_val - 1
               true -> prev_val + 1
             end
           end) == 10
  end
end
