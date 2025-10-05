defmodule Day21.FractalArtTest do
  use ExUnit.Case, async: true
  alias Day21.FractalArt

  test "part1 - lit pixel after 3 iterations" do
    input = """
    ../.# => ##./#../...
    .#./..#/### => #..#/..../..../#..#
    """

    assert FractalArt.part1_with_input(input, 2) == 12
  end
end
