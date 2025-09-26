defmodule Day05.TwistyTrampolinesTest do
  use ExUnit.Case, async: true
  alias Day05.TwistyTrampolines

  test "part 1 - exit in 5 moves" do
    jump("0 3  0  1  -3")
  end
end
