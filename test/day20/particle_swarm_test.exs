defmodule Day20.ParticleSwarmTest do
  use ExUnit.Case, async: true
  alias Day20.ParticleSwarm

  test "part1 - closest to origin" do
    input = """
    p=<3,0,0>, v=<2,0,0>, a=<-1,0,0>
    p=<4,0,0>, v=<0,0,0>, a=<-2,0,0>
    """

    assert ParticleSwarm.part1_with_input(input) == 0
  end

  test "part2 - count after collision" do
    input = """
    p=<-6,0,0>, v=<3,0,0>, a=<0,0,0>
    p=<-4,0,0>, v=<2,0,0>, a=<0,0,0>
    p=<-2,0,0>, v=<1,0,0>, a=<0,0,0>
    p=<3,0,0>, v=<-1,0,0>, a=<0,0,0>
    """

    assert ParticleSwarm.part2_with_input(input) == 1
  end
end
