defmodule Day13.PacketScannersTest do
  use ExUnit.Case, async: true
  alias Day13.PacketScanners

  test "part1 - whole trip severity" do
    input = """
    0: 3
    1: 2
    4: 4
    6: 4
    """

    severity =
      input
      |> PacketScanners.parse()
      |> PacketScanners.calculate_severity()

    assert severity == 24
  end

  test "part2 - min delay to not get caught" do
    input = """
    0: 3
    1: 2
    4: 4
    6: 4
    """

    min_delay =
      input
      |> PacketScanners.parse()
      |> PacketScanners.min_delay_to_pass()

    assert min_delay == 10
  end
end
