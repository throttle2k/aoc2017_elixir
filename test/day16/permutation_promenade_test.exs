defmodule Day16.PermutationPromenadeTest do
  use ExUnit.Case, async: true
  alias Day16.PermutationPromenade

  test "part1 - dance" do
    input = "s1,x3/4,pe/b"
    initial_state = PermutationPromenade.generate_initial_state(5)

    input
    |> PermutationPromenade.parse()
    |> PermutationPromenade.dance(initial_state)
    |> PermutationPromenade.state_to_string()
  end

  test "part2 - 1_000_000_000 dances" do
    input = "s1,x3/4,pe/b"
    initial_state = PermutationPromenade.generate_initial_state(5)

    input
    |> PermutationPromenade.parse()
    |> PermutationPromenade.repeated_dance(initial_state, 1_000_000_000)
    |> PermutationPromenade.state_to_string()
  end
end
