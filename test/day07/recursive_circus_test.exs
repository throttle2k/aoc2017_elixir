defmodule Day07.RecursiveCircusTest do
  use ExUnit.Case, async: true
  alias Day07.RecursiveCircus

  test "part1 - find bottom program" do
    input = """
    pbga (66)
    xhth (57)
    ebii (61)
    havc (66)
    ktlj (57)
    fwft (72) -> ktlj, cntj, xhth
    qoyq (66)
    padx (45) -> pbga, havc, qoyq
    tknk (41) -> ugml, padx, fwft
    jptl (61)
    ugml (68) -> gyxo, ebii, jptl
    gyxo (61)
    cntj (57)
    """

    assert input
           |> RecursiveCircus.parse()
           |> RecursiveCircus.find_bottom() ==
             "tknk"
  end

  test "part2 - find correct weight" do
    input = """
    pbga (66)
    xhth (57)
    ebii (61)
    havc (66)
    ktlj (57)
    fwft (72) -> ktlj, cntj, xhth
    qoyq (66)
    padx (45) -> pbga, havc, qoyq
    tknk (41) -> ugml, padx, fwft
    jptl (61)
    ugml (68) -> gyxo, ebii, jptl
    gyxo (61)
    cntj (57)
    """

    graph =
      input
      |> RecursiveCircus.parse()

    bottom = RecursiveCircus.find_bottom(graph)
    graph = RecursiveCircus.process_siblings(graph, bottom)
    assert RecursiveCircus.find_correct_weight(graph, bottom) == 60
  end
end
