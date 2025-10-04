defmodule Day19.ASeriesOfTubesTest do
  use ExUnit.Case, async: true
  alias Day19.ASeriesOfTubes

  test "part1 - letters in path" do
    input = """
        |           
        |  +--+    
        A  |  C    
    F---|----E|--+ 
        |  |  |  D 
        +B-+  +--+ 

    """

    assert ASeriesOfTubes.part1_with_input(input) == "ABCDEF"
  end

  test "part2 - count steps" do
    input = """
        |           
        |  +--+    
        A  |  C    
    F---|----E|--+ 
        |  |  |  D 
        +B-+  +--+ 

    """

    assert ASeriesOfTubes.part2_with_input(input) == 38
  end
end
